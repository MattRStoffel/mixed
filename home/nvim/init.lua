-- =============================================================================
-- OPTIONS
-- =============================================================================

vim.g.mapleader      = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

local o = vim.opt
o.expandtab      = true
o.tabstop        = 2
o.shiftwidth     = 2
o.softtabstop    = 2
o.number         = true
o.relativenumber = true
o.mouse          = "a"
o.breakindent    = true
o.undofile       = true
o.ignorecase     = true
o.smartcase      = true
o.signcolumn     = "yes"
o.updatetime     = 250
o.timeoutlen     = 300
o.splitright     = true
o.splitbelow     = true
o.list           = false
o.listchars      = { tab = "» ", trail = "·", nbsp = "␣" }
o.inccommand     = "split"
o.cursorline     = true
o.scrolloff      = 6
o.completeopt    = { "menuone", "noselect", "noinsert" }
o.pumheight      = 5
o.termguicolors  = true
o.shortmess:append("c")

vim.schedule(function() o.clipboard = "unnamedplus" end)

-- =============================================================================
-- KEYMAPS
-- =============================================================================

local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>")

map("n", "<C-h>", "<C-w><C-h>", { desc = "Focus left window"  })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Focus right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Focus lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Focus upper window" })

map("n", "<M-,>", "<C-w>5<")
map("n", "<M-.>", "<C-w>5>")
map("n", "<M-t>", "<C-w>5+")
map("n", "<M-s>", "<C-w>5-")

-- python3 ships with macOS; `python` does not.
vim.api.nvim_create_user_command("FormatJson", ":%!python3 -m json.tool", {})
map("n", "<Leader>j", ":FormatJson<CR>", { desc = "Format buffer as JSON" })

-- =============================================================================
-- PICKER
-- =============================================================================

local Picker = (function()
    local api = vim.api
    local fn  = vim.fn
    local uv  = vim.loop

    -- ── Fuzzy scorer ──────────────────────────────────────────────────────
    -- Subsequence match: all query chars must appear in order in the candidate.
    -- Consecutive char runs score higher; shorter candidates score slightly higher.

    local function fuzzy_match(query, candidate)
        if query == "" then return true, 0 end
        local ql = query:lower()
        local cl = candidate:lower()
        local qi, ci = 1, 1
        local score, run = 0, 0
        while qi <= #ql and ci <= #cl do
            if ql:sub(qi, qi) == cl:sub(ci, ci) then
                run   = run + 1
                score = score + run   -- consecutive streak bonus
                qi    = qi + 1
            else
                run = 0
            end
            ci = ci + 1
        end
        if qi > #ql then
            return true, score - #candidate * 0.01   -- length penalty
        end
        return false, 0
    end

    -- ── State ─────────────────────────────────────────────────────────────

    local S = {}

    local function reset()
        if S.job_id        then pcall(fn.jobstop, S.job_id) end
        if S.debounce_timer then
            S.debounce_timer:stop()
            S.debounce_timer:close()
        end
        S = {
            mode           = nil,   -- "files" | "grep"
            bufs           = {},    -- keyed: input, results, preview
            wins           = {},
            all_items      = {},    -- raw strings streamed from the source job
            filtered       = {},    -- { text=string, score=number }
            cursor         = 0,
            query          = "",
            job_id         = nil,
            debounce_timer = nil,
        }
    end

    -- ── Window layout ─────────────────────────────────────────────────────

    local function new_buf()
        local buf = api.nvim_create_buf(false, true)
        vim.bo[buf].bufhidden = "wipe"
        vim.bo[buf].buftype   = "nofile"
        vim.bo[buf].swapfile  = false
        return buf
    end

    local function create_windows()
        local cols  = vim.o.columns
        local rows  = vim.o.lines
        local W     = math.floor(cols * 0.88)
        local H     = math.floor(rows * 0.80)
        local left  = math.floor((cols - W) / 2)
        local top   = math.floor((rows - H) / 2)

        -- input: 1 line, full picker width
        local inp_h  = 1
        -- body: total height minus input row + its two border lines
        local body_h = H - inp_h - 3
        local prev_w = math.floor(W * 0.50)
        local res_w  = W - prev_w - 1   -- 1 col gap between panes

        local base = { relative = "editor", style = "minimal", border = "rounded" }

        local b_inp = new_buf()
        local w_inp = api.nvim_open_win(b_inp, true, vim.tbl_extend("force", base, {
            row = top, col = left, width = W, height = inp_h,
            title = " Picker ", title_pos = "center",
        }))

        local b_res = new_buf()
        local w_res = api.nvim_open_win(b_res, false, vim.tbl_extend("force", base, {
            row = top + inp_h + 2, col = left,
            width = res_w, height = body_h,
            title = " Results ", title_pos = "center",
        }))

        local b_prv = new_buf()
        local w_prv = api.nvim_open_win(b_prv, false, vim.tbl_extend("force", base, {
            row = top + inp_h + 2, col = left + res_w + 1,
            width = prev_w, height = body_h,
            title = " Preview ", title_pos = "center",
        }))

        for _, w in ipairs({ w_inp, w_res, w_prv }) do
            vim.wo[w].wrap       = false
            vim.wo[w].number     = false
            vim.wo[w].signcolumn = "no"
            vim.wo[w].cursorline = false
        end
        vim.wo[w_res].cursorline = true

        S.bufs = { input = b_inp, results = b_res, preview = b_prv }
        S.wins = { input = w_inp, results = w_res, preview = w_prv }
    end

    -- ── Close ─────────────────────────────────────────────────────────────

    local function close()
        if S.job_id then pcall(fn.jobstop, S.job_id); S.job_id = nil end
        if S.debounce_timer then
            S.debounce_timer:stop()
            S.debounce_timer:close()
            S.debounce_timer = nil
        end
        for _, w in pairs(S.wins or {}) do
            if api.nvim_win_is_valid(w) then api.nvim_win_close(w, true) end
        end
        vim.cmd("stopinsert")
    end

    -- ── Rendering ─────────────────────────────────────────────────────────

    local ns = api.nvim_create_namespace("picker_hl")

    -- Map common file extensions → Neovim filetypes for preview syntax.
    local EXT_FT = {
        lua="lua",   py="python",   js="javascript",   ts="typescript",
        jsx="javascriptreact",      tsx="typescriptreact",
        swift="swift", hs="haskell", c="c",  cpp="cpp",  h="c",
        json="json",  md="markdown", sh="sh", bash="sh",  zsh="sh",
        yaml="yaml",  yml="yaml",   toml="toml", go="go", rs="rust",
        rb="ruby",    java="java",  kt="kotlin", html="html", css="css",
    }

    local function render_results()
        if not api.nvim_buf_is_valid(S.bufs.results) then return end
        local lines = {}
        for i, item in ipairs(S.filtered) do
            lines[i] = (i == S.cursor and "▶ " or "  ") .. item.text
        end
        api.nvim_buf_set_lines(S.bufs.results, 0, -1, false, lines)
        api.nvim_buf_clear_namespace(S.bufs.results, ns, 0, -1)
        if S.cursor > 0 then
            api.nvim_buf_add_highlight(S.bufs.results, ns, "PmenuSel", S.cursor - 1, 0, -1)
        end
        if api.nvim_win_is_valid(S.wins.results) and S.cursor > 0 then
            api.nvim_win_set_cursor(S.wins.results, { S.cursor, 0 })
        end
    end

    local function render_preview()
        if not api.nvim_buf_is_valid(S.bufs.preview) then return end
        local item = S.filtered[S.cursor]
        if not item then
            api.nvim_buf_set_lines(S.bufs.preview, 0, -1, false, {})
            return
        end

        -- grep lines look like  path:lnum:col:content
        local path, lnum
        if S.mode == "grep" then
            path, lnum = item.text:match("^([^:]+):(%d+):")
            lnum = tonumber(lnum)
        else
            path, lnum = item.text, nil
        end

        if not path or fn.filereadable(path) == 0 then
            api.nvim_buf_set_lines(S.bufs.preview, 0, -1, false, { "(not readable)" })
            return
        end

        -- readfile is synchronous; cap at 300 lines so it stays fast.
        local ok, file_lines = pcall(fn.readfile, path, "", 300)
        if not ok then
            api.nvim_buf_set_lines(S.bufs.preview, 0, -1, false, { "(read error)" })
            return
        end

        -- nvim_buf_set_lines rejects strings that contain newline characters.
        -- readfile can produce \r on CRLF files, or \n in pathological cases.
        for i, line in ipairs(file_lines) do
            file_lines[i] = line:gsub("[\r\n]", "")
        end

        api.nvim_buf_set_lines(S.bufs.preview, 0, -1, false, file_lines)

        local ext = path:match("%.([^.]+)$")
        vim.bo[S.bufs.preview].filetype = (ext and EXT_FT[ext]) or ""

        -- Scroll to matched line and highlight it.
        api.nvim_buf_clear_namespace(S.bufs.preview, ns, 0, -1)
        local target = math.max(1, math.min(lnum or 1, #file_lines))
        if api.nvim_win_is_valid(S.wins.preview) then
            api.nvim_win_set_cursor(S.wins.preview, { target, 0 })
        end
        if lnum then
            api.nvim_buf_add_highlight(S.bufs.preview, ns, "Search", target - 1, 0, -1)
        end
    end

    -- ── Filtering (files mode) ─────────────────────────────────────────────

    local function apply_filter()
        local scored = {}
        for _, text in ipairs(S.all_items) do
            local ok, score = fuzzy_match(S.query, text)
            if ok then scored[#scored + 1] = { text = text, score = score } end
        end
        table.sort(scored, function(a, b) return a.score > b.score end)
        S.filtered = scored
        S.cursor   = #scored > 0 and 1 or 0
        render_results()
        render_preview()
    end

    -- ── Debounce ──────────────────────────────────────────────────────────
    -- Reuses a single uv timer; resets the countdown on every call.

    local function debounce(callback, ms)
        if not S.debounce_timer then S.debounce_timer = uv.new_timer() end
        S.debounce_timer:stop()
        S.debounce_timer:start(ms, 0, vim.schedule_wrap(callback))
    end

    -- ── Source jobs ───────────────────────────────────────────────────────

    local function in_git_repo()
        -- git rev-parse is the canonical way to check; fast, no grep needed.
        return fn.systemlist("git rev-parse --is-inside-work-tree 2>/dev/null")[1] == "true"
    end

    local function start_files_job()
        local cmd = in_git_repo()
            -- Natively respects .gitignore, .git/info/exclude, and global excludes.
            and { "git", "ls-files", "--cached", "--others", "--exclude-standard" }
            -- Fallback for non-git trees: manual exclusions via find.
            or  { "find", ".", "-type", "f",
                  "-not", "-path", "*/.git/*",
                  "-not", "-path", "*/node_modules/*",
                  "-not", "-path", "*/__pycache__/*",
                  "-not", "-name", ".DS_Store" }

        S.all_items = {}
        S.job_id = fn.jobstart(cmd, {
            cwd             = fn.getcwd(),
            stdout_buffered = false,   -- stream; don't wait for job to finish
            on_stdout = function(_, data)
                local grew = false
                for _, line in ipairs(data) do
                    if line ~= "" then
                        S.all_items[#S.all_items + 1] = line
                        grew = true
                    end
                end
                -- Refilter on each chunk so results appear incrementally.
                if grew then debounce(apply_filter, 30) end
            end,
            on_exit = function()
                S.job_id = nil
                vim.schedule(apply_filter)
            end,
        })
    end

    local function start_grep_job(pattern)
        if S.job_id then pcall(fn.jobstop, S.job_id); S.job_id = nil end

        if pattern == "" then
            S.filtered = {}; S.cursor = 0
            render_results()
            api.nvim_buf_set_lines(S.bufs.preview, 0, -1, false,
                { "", "   type to search…" })
            return
        end

        local cwd = fn.getcwd()
        S.all_items = {}
        S.job_id = fn.jobstart({
            "grep", "-rIn",
            "--exclude-dir=.git",
            "--exclude-dir=node_modules",
            "--exclude-dir=__pycache__",
            pattern, cwd,
        }, {
            stdout_buffered = false,
            on_stdout = function(_, data)
                local grew = false
                for _, line in ipairs(data) do
                    if line ~= "" then
                        -- Strip absolute cwd prefix for cleaner display.
                        local rel = line:gsub("^" .. vim.pesc(cwd) .. "/", "", 1)
                        S.all_items[#S.all_items + 1] = rel
                        grew = true
                    end
                end
                if grew then
                    vim.schedule(function()
                        S.filtered = {}
                        for _, t in ipairs(S.all_items) do
                            S.filtered[#S.filtered + 1] = { text = t }
                        end
                        -- Keep cursor at 1 on new results; preserve on appends.
                        if S.cursor == 0 then S.cursor = 1 end
                        render_results()
                        render_preview()
                    end)
                end
            end,
            on_exit = function() S.job_id = nil end,
        })
    end

    -- ── Input handling ────────────────────────────────────────────────────

    local function on_input_change()
        local line = (api.nvim_buf_get_lines(S.bufs.input, 0, 1, false)[1] or "")
        if line == S.query then return end
        S.query = line
        if S.mode == "files" then
            debounce(apply_filter, 40)
        else
            debounce(function() start_grep_job(line) end, 120)
        end
    end

    local function move(delta)
        if #S.filtered == 0 then return end
        S.cursor = ((S.cursor - 1 + delta) % #S.filtered) + 1
        render_results()
        render_preview()
    end

    local function confirm(open_cmd)
        local item = S.filtered[S.cursor]
        if not item then return end
    
        local path, lnum, col
        if S.mode == "grep" then
            path, lnum, col = item.text:match("^([^:]+):(%d+):")
            lnum = tonumber(lnum)
            col  = math.max(0, (tonumber(col) or 1) - 1)
        else
            path = item.text
        end
    
        close()
    
        if path and path ~= "" then
            -- 1. Get the absolute path of the target and current file
            local target_path = vim.fn.fnamemodify(path, ":p")
            local current_path = vim.fn.expand("%:p")
    
            -- 2. Only run the "edit" command if we aren't already there
            if target_path ~= current_path then
                vim.cmd((open_cmd or "edit") .. " " .. vim.fn.fnameescape(path))
            end
    
            -- 3. Always move the cursor (this works whether we just opened it or were already there)
            if lnum then
                -- Use pcall to catch errors if the line number is out of range
                pcall(api.nvim_win_set_cursor, 0, { lnum, col })
            end
        end
    end

    -- ── Keymaps (scoped to the input buffer) ──────────────────────────────

    local function set_keymaps()
        local opts = { buffer = S.bufs.input, nowait = true, silent = true }
        local m    = vim.keymap.set

        m({ "i", "n" }, "<Esc>",  close,                         opts)
        m({ "i", "n" }, "<C-c>",  close,                         opts)
        m({ "i", "n" }, "<CR>",   function() confirm("edit")   end, opts)
        m({ "i", "n" }, "<C-v>",  function() confirm("vsplit") end, opts)
        m({ "i", "n" }, "<C-x>",  function() confirm("split")  end, opts)
        m({ "i", "n" }, "<C-j>",  function() move(1)           end, opts)
        m({ "i", "n" }, "<C-k>",  function() move(-1)          end, opts)
        m({ "i", "n" }, "<Down>", function() move(1)           end, opts)
        m({ "i", "n" }, "<Up>",   function() move(-1)          end, opts)
    end

    -- ── Public API ────────────────────────────────────────────────────────

    local M = {}

    function M.find_files()
        reset()
        S.mode = "files"
        create_windows()
        set_keymaps()
        api.nvim_create_autocmd({ "TextChangedI", "TextChanged" }, {
            buffer   = S.bufs.input,
            callback = on_input_change,
        })
        api.nvim_set_current_win(S.wins.input)
        vim.cmd("startinsert")
        start_files_job()
    end

    function M.live_grep()
        reset()
        S.mode = "grep"
        create_windows()
        set_keymaps()
        api.nvim_create_autocmd({ "TextChangedI", "TextChanged" }, {
            buffer   = S.bufs.input,
            callback = on_input_change,
        })
        api.nvim_set_current_win(S.wins.input)
        vim.cmd("startinsert")
        api.nvim_buf_set_lines(S.bufs.preview, 0, -1, false,
            { "", "   type to search…" })
    end

    return M
end)()

map("n", "<Leader><Leader>", Picker.find_files, { desc = "Picker: find files" })
map("n", "<Leader>/",        Picker.live_grep,  { desc = "Picker: live grep"  })

-- =============================================================================
-- LSP
-- =============================================================================
--
-- Install notes (none ship with macOS but each is one command):
--   sourcekit  — xcrun sourcekit-lsp  (ships with Xcode / `xcode-select --install`)
--   pyright    — npm install -g pyright
--   hls        — ghcup install hls
-- =============================================================================

local LSP = {}

function LSP.on_attach(client, bufnr)
    -- Modern way to set buffer options
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    
    local opts = { buffer = bufnr, remap = false }
    map("n", "gd", vim.lsp.buf.definition, opts)
    map("n", "K",  vim.lsp.buf.hover,       opts)
    
    -- Improved <C-y> logic
    map("i", "<C-y>", function()
        return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-x><C-o>"
    end, { expr = true, replace_keycodes = true, buffer = bufnr })
end

local servers = {
    sourcekit = {
        cmd          = { "xcrun", "sourcekit-lsp" },
        filetypes    = { "swift", "objective-c", "objective-cpp" },
        root_markers = { "Package.swift", "*.xcodeproj", ".git" },
        settings     = {},
    },
    pyright = {
        cmd          = { "pyright-langserver", "--stdio" },
        filetypes    = { "python" },
        root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
        settings     = {
            python = { analysis = { autoSearchPaths = true, useLibraryCodeForTypes = true } },
        },
    },
    hls = {
        cmd          = { "haskell-language-server-wrapper", "--lsp" },
        filetypes    = { "haskell", "lhaskell" },
        root_markers = { "cabal.project", "stack.yaml", "package.yaml", "*.cabal", ".git" },
        settings     = {},
    },
}

for name, cfg in pairs(servers) do
    vim.api.nvim_create_autocmd("FileType", {
        pattern  = cfg.filetypes,
        callback = function(args)
            local root_file = vim.fs.find(cfg.root_markers, { upward = true })[1]
            local root_dir  = root_file and vim.fs.dirname(root_file) or vim.fn.getcwd()
            
            vim.lsp.start({
                name     = name,
                cmd      = cfg.cmd,
                root_dir = root_dir,
                settings = cfg.settings,
                -- Pass the client and bufnr to our attach function
                on_attach = LSP.on_attach,
            })
        end,
    })
end

-- =============================================================================
-- COMPLETION  (auto-popup on word chars and `.`)
-- =============================================================================

vim.api.nvim_create_autocmd("TextChangedI", {
    pattern  = "*",
    callback = function()
        -- Only trigger if omnifunc is actually set to avoid the error
        if vim.bo.omnifunc == "" then return end

        local col = vim.api.nvim_win_get_cursor(0)[2]
        local line = vim.api.nvim_get_current_line()
        local char_before = line:sub(col, col)

        -- Don't trigger if the popup is already visible
        if vim.fn.pumvisible() == 1 then return end

        if char_before == "." or char_before:match("%w") then
            -- Use a slight delay to prevent overwhelming the LSP
            vim.defer_fn(function()
                -- Check again if we are still in insert mode and at a valid spot
                local cur_col = vim.api.nvim_win_get_cursor(0)[2]
                if vim.api.nvim_get_mode().mode == 'i' and cur_col == col then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-x><C-o>", true, true, true), "n")
                end
            end, 50) -- 50ms "debounce" helps with typing speed
        end
    end,
})

-- =============================================================================
-- THEME  (Tokyo Night palette)
-- =============================================================================

local c = {
    bg      = "#1a1b26",
    bg_dark = "#16161e",
    fg      = "#c0caf5",
    cyan    = "#7dcfff",
    purple  = "#bb9af7",
    orange  = "#ff9e64",
    red     = "#f7768e",
    green   = "#9ece6a",
    yellow  = "#e0af68",
    comment = "#565f89",
}

local function hl(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- Editor
hl("Normal",    { fg = c.fg,  bg = c.bg })
hl("CursorLine",{ bg = "#292e42" })
hl("Visual",    { bg = "#283457" })
hl("Search",    { fg = c.bg,  bg = c.yellow })
hl("IncSearch", { fg = c.bg,  bg = c.orange })
hl("LineNr",    { fg = "#3b4261" })

-- Syntax
hl("Comment",    { fg = c.comment, italic = true })
hl("Constant",   { fg = c.orange  })
hl("String",     { fg = c.green   })
hl("Identifier", { fg = c.red     })
hl("Function",   { fg = c.cyan    })
hl("Statement",  { fg = c.purple  })
hl("PreProc",    { fg = c.cyan    })
hl("Type",       { fg = c.yellow  })
hl("Special",    { fg = c.purple  })
hl("Underlined", { underline = true })
hl("Error",      { fg = c.red,  bold = true })
hl("Todo",       { fg = c.bg,   bg = c.cyan, bold = true })

-- LSP diagnostics
hl("DiagnosticError", { fg = c.red    })
hl("DiagnosticWarn",  { fg = c.yellow })
hl("DiagnosticInfo",  { fg = c.cyan   })
hl("DiagnosticHint",  { fg = c.purple })

-- Completion menu
hl("Pmenu",    { bg = c.bg_dark, fg = c.fg })
hl("PmenuSel", { bg = "#3b4261", bold = true })
