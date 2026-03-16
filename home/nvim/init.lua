-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

-- [[ Setting options ]]
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
-- vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
vim.schedule(function()
    vim.opt.clipboard = "unnamedplus"
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = false
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 6

-- [[ Basic Keymaps ]]

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Keybinds to make split navigation easier.
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<M-,>", "<c-w>5<")
vim.keymap.set("n", "<M-.>", "<c-w>5>")
vim.keymap.set("n", "<M-t>", "<c-w>5+")
vim.keymap.set("n", "<M-s>", "<c-w>5-")

-- format json
vim.api.nvim_create_user_command("FormatJson", ":%!python -m json.tool", {})
vim.keymap.set("n", "<Leader>j", ":FormatJson<CR>", { desc = "Format current file as JSON" })

-- ========================================================================== --
-- ==                                   Picker                                 == --
-- ========================================================================== --

local Picker = {}

-- 1. UI: Create the Floating Window
function Picker.create_win()
    local width = math.ceil(vim.o.columns * 0.9)
    local height = math.ceil(vim.o.lines * 0.8)
    local row = math.ceil((vim.o.lines - height - 2) / 3)
    local col = math.ceil((vim.o.columns - width) / 2)

    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor", width = width, height = height,
        row = row, col = col, style = "minimal", border = "rounded"
    })
    return buf, win
end

-- 2. Engine: The Shell/Terminal Handler
function Picker.run(opts)
    local buf, win = Picker.create_win()

    local base_fzf = {
        "fzf",
        "--ansi",
        "--reverse",
        "--bind 'ctrl-j:down,ctrl-k:up'",
    }

    local full_cmd = table.concat(base_fzf, " ") .. " " .. (opts.cmd or "")

    vim.fn.termopen(full_cmd, {
        on_exit = function(_, code)
            if code == 0 then
                local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
                local selection = lines[1]
                vim.api.nvim_win_close(win, true)
                if selection and selection ~= "" then
                    opts.on_select(selection)
                end
            else
                vim.api.nvim_win_close(win, true)
            end
        end
    })
    vim.cmd("startinsert")
end

-- 3. Features: Specific Search Actions
function Picker.find_files()
    Picker.run({
        cmd = "--prompt '> ' --preview 'bat --style=plain --color=always {}'",
        on_select = function(selection)
            vim.cmd("edit " .. selection)
        end
    })
end

function Picker.live_grep()
    local rg_cmd = "rg --column --line-number --no-heading --color=always --smart-case {q} || :"
    local preview_cmd = "bat --style=numbers --color=always --highlight-line {2} {1}"

    Picker.run({
        cmd = "--phony --delimiter ':' --prompt '> ' " ..
              "--bind 'change:reload(" .. rg_cmd .. ")' " ..
              "--preview '" .. preview_cmd .. "'",
        on_select = function(selection)
            local parts = vim.split(selection, ":")
            if #parts >= 3 then
                vim.cmd("edit " .. parts[1])
                vim.api.nvim_win_set_cursor(0, {tonumber(parts[2]), tonumber(parts[3]) - 1})
            end
        end
    })
end

-- 4. Integration: Keymaps
vim.keymap.set("n", "<Leader><Leader>", Picker.find_files, { desc = "FZF Project Files" })
vim.keymap.set("n", "<Leader>/", Picker.live_grep, { desc = "FZF Live Grep" })

-- ========================================================================== --
-- ==                                 LSP                                  == --
-- ========================================================================== --
local LSP = {}

-- Logic to be applied to a buffer when an LSP attaches
function LSP.on_attach(bufnr)
    local opts = { buffer = bufnr, remap = false }

    -- Link LSP to Omnifunc for built-in completion
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Navigation Keymaps
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

    -- Manual Trigger / Tab Navigation
    vim.keymap.set("i", "<Tab>", function()
        if vim.fn.pumvisible() == 1 then
            return "<C-n>"
        end
        return "<C-x><C-o>"
    end, { expr = true, replace_keycodes = true, buffer = bufnr })
end

-- Server Definitions
local servers = {
    pyright = {
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = "python",
        root_markers = { "pyproject.toml", "setup.py", ".git", "requirements.txt" },
        settings = {
            python = {
                analysis = {
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                },
            },
        },
    },
}

-- Initialize Servers via Loop
for name, config in pairs(servers) do
    vim.api.nvim_create_autocmd("FileType", {
        pattern = config.filetypes,
        callback = function(args)
            local root_file = vim.fs.find(config.root_markers, { upward = true })[1]
            local root_dir = root_file and vim.fs.dirname(root_file) or vim.fn.getcwd()

            local client_id = vim.lsp.start({
                name = name,
                cmd = config.cmd,
                root_dir = root_dir,
                settings = config.settings,
            })

            if client_id then
                LSP.on_attach(args.buf)
            else
                print("LSP failed to start: " .. name)
            end
        end,
    })
end

-- ========================================================================== --
-- ==                                 CMP                                  == --
-- ========================================================================== --
vim.opt_local
-- 1. Behavior & Menu Options
vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
vim.opt.shortmess:append("c") -- Silence completion messages in cmdline
vim.opt.pumheight = 5         -- Max 5 items in the list

-- 2. Auto-Popup Logic (Dot trigger and Word trigger)
vim.api.nvim_create_autocmd("TextChangedI", {
    pattern = "*",
    callback = function()
        local line = vim.api.nvim_get_current_line()
        local col = vim.api.nvim_win_get_cursor(0)[2]
        local char_before = line:sub(col, col)

        -- Trigger if last char is '.' OR if typing any word character
        if char_before == "." or (vim.fn.pumvisible() == 0 and char_before:match("%w")) then
            vim.schedule(function()
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-x><C-o>", true, true, true), "n")
            end)
        end
    end,
})

local colors = {
    bg      = "#1a1b26", -- Deep Night Blue
    bg_dark = "#16161e", -- Darker background (for statusline/pickers)
    fg      = "#c0caf5", -- Soft Silver/Blue text
    cyan    = "#7dcfff", -- Teal/Cyan
    purple  = "#bb9af7", -- Violet/Purple
    orange  = "#ff9e64", -- Orange/Peach
    pink    = "#bb9af7", -- Pink/Magenta
    red     = "#f7768e", -- Soft Red
    green   = "#9ece6a", -- Sage Green
    yellow  = "#e0af68", -- Soft Yellow
    comment = "#565f89", -- Muted Blue-Grey
}
-- Ensure Termguicolors is on for hex codes to work
vim.opt.termguicolors = true

-- Helper function to make the table easier to read
local function hl(group, options)
    vim.api.nvim_set_hl(0, group, options)
end

-- --- Editor UI ---
hl("Normal", { fg = colors.fg, bg = colors.bg })
hl("CursorLine", { bg = "#292e42" })
hl("Visual", { bg = "#283457" })
hl("Search", { fg = colors.bg, bg = colors.yellow })
hl("IncSearch", { fg = colors.bg, bg = colors.orange })
hl("LineNr", { fg = "#3b4261" })

-- --- Syntax Highlighting ---
hl("Comment", { fg = colors.comment, italic = true })
hl("Constant", { fg = colors.orange })
hl("String", { fg = colors.green })
hl("Identifier", { fg = colors.red })
hl("Function", { fg = colors.cyan })
hl("Statement", { fg = colors.purple })
hl("PreProc", { fg = colors.cyan })
hl("Type", { fg = colors.yellow })
hl("Special", { fg = colors.purple })
hl("Underlined", { underline = true })
hl("Error", { fg = colors.red, bold = true })
hl("Todo", { fg = colors.bg, bg = colors.cyan, bold = true })

-- --- LSP & Completion (Fits your manual setup) ---
hl("DiagnosticError", { fg = colors.red })
hl("DiagnosticWarn", { fg = colors.yellow })
hl("DiagnosticInfo", { fg = colors.cyan })
hl("DiagnosticHint", { fg = colors.purple })

-- Your Picker/CMP UI (Updating your existing styles)
hl("Pmenu", { bg = colors.bg_dark, fg = colors.fg })
hl("PmenuSel", { bg = "#3b4261", bold = true })

