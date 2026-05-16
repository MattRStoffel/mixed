{pkgs, ...}: {
  programs.neovim = {
    enable        = true;
    defaultEditor = true;
    viAlias       = true;
    vimAlias      = true;
    vimdiffAlias  = true;
    extraPackages = with pkgs; [
      nodejs
      gcc
      clang
      unzip
      go
      haskell-language-server
    ];
  };

  xdg.configFile = {
    "nvim/init.lua".source                   = ./init.lua;
    "nvim/lua/config/options.lua".source     = ./lua/config/options.lua;
    "nvim/lua/config/keymaps.lua".source     = ./lua/config/keymaps.lua;
    "nvim/lua/plugins/telescope.lua".source  = ./lua/plugins/telescope.lua;
    "nvim/lua/plugins/lsp.lua".source        = ./lua/plugins/lsp.lua;
    "nvim/lua/plugins/completion.lua".source  = ./lua/plugins/completion.lua;
    "nvim/lua/plugins/colorizer.lua".source   = ./lua/plugins/colorizer.lua;
    "nvim/lua/plugins/theme.lua".text = ''
      return {}
    '';
    "nvim/colors/nix-theme.lua".text = let c = (import ../../theme.nix).colors; in ''
      vim.o.background = "dark"
      vim.cmd("hi clear")
      if vim.fn.exists("syntax_on") == 1 then vim.cmd("syntax reset") end
      vim.g.colors_name = "nix-theme"

      local hi      = vim.api.nvim_set_hl
      local bg      = "#${c.background}"
      local surface = "#${c.surface}"
      local fg      = "#${c.text}"
      local cyan    = "#${c.cyan}"
      local purple  = "#${c.magenta}"
      local gold    = "#${c.yellow}"
      local red     = "#${c.red}"
      local muted   = "#${c.brightBlack}"

      -- Editor chrome
      hi(0, "Normal",        { fg = fg,   bg = bg })
      hi(0, "NormalFloat",   { fg = fg,   bg = surface })
      hi(0, "NormalNC",      { fg = fg,   bg = bg })
      hi(0, "SignColumn",    { bg = bg })
      hi(0, "ColorColumn",   { bg = surface })
      hi(0, "CursorLine",    { bg = surface })
      hi(0, "CursorColumn",  { bg = surface })
      hi(0, "CursorLineNr",  { fg = gold, bold = true })
      hi(0, "LineNr",        { fg = muted })
      hi(0, "WinSeparator",  { fg = muted })
      hi(0, "EndOfBuffer",   { fg = muted })
      hi(0, "Folded",        { fg = muted, bg = surface })
      hi(0, "FoldColumn",    { fg = muted, bg = bg })
      hi(0, "MatchParen",    { fg = gold,  bold = true })

      -- Selection / search
      hi(0, "Visual",        { bg = surface })
      hi(0, "Search",        { fg = bg,   bg = gold })
      hi(0, "IncSearch",     { fg = bg,   bg = red })
      hi(0, "Substitute",    { fg = bg,   bg = red })

      -- Status / tab
      hi(0, "StatusLine",    { fg = fg,    bg = surface })
      hi(0, "StatusLineNC",  { fg = muted, bg = surface })
      hi(0, "TabLine",       { fg = muted, bg = surface })
      hi(0, "TabLineFill",   { bg = bg })
      hi(0, "TabLineSel",    { fg = fg,    bg = bg })

      -- Popup menu
      hi(0, "Pmenu",         { fg = fg,   bg = surface })
      hi(0, "PmenuSel",      { fg = bg,   bg = cyan })
      hi(0, "PmenuSbar",     { bg = surface })
      hi(0, "PmenuThumb",    { bg = muted })

      -- Syntax
      hi(0, "Comment",       { fg = muted,   italic = true })
      hi(0, "Constant",      { fg = gold })
      hi(0, "String",        { fg = cyan })
      hi(0, "Character",     { fg = cyan })
      hi(0, "Number",        { fg = gold })
      hi(0, "Boolean",       { fg = red })
      hi(0, "Float",         { fg = gold })
      hi(0, "Identifier",    { fg = fg })
      hi(0, "Function",      { fg = cyan })
      hi(0, "Statement",     { fg = purple })
      hi(0, "Conditional",   { fg = purple })
      hi(0, "Repeat",        { fg = purple })
      hi(0, "Label",         { fg = purple })
      hi(0, "Operator",      { fg = fg })
      hi(0, "Keyword",       { fg = purple })
      hi(0, "Exception",     { fg = red })
      hi(0, "PreProc",       { fg = cyan })
      hi(0, "Include",       { fg = purple })
      hi(0, "Type",          { fg = purple })
      hi(0, "StorageClass",  { fg = purple })
      hi(0, "Structure",     { fg = purple })
      hi(0, "Typedef",       { fg = purple })
      hi(0, "Special",       { fg = gold })
      hi(0, "Error",         { fg = red })
      hi(0, "Todo",          { fg = bg,   bg = gold, bold = true })
      hi(0, "Underlined",    { underline = true })

      -- Diagnostics
      hi(0, "DiagnosticError",           { fg = red })
      hi(0, "DiagnosticWarn",            { fg = gold })
      hi(0, "DiagnosticInfo",            { fg = cyan })
      hi(0, "DiagnosticHint",            { fg = muted })
      hi(0, "DiagnosticUnderlineError",  { undercurl = true, sp = red })
      hi(0, "DiagnosticUnderlineWarn",   { undercurl = true, sp = gold })
      hi(0, "DiagnosticUnderlineInfo",   { undercurl = true, sp = cyan })
      hi(0, "DiagnosticUnderlineHint",   { undercurl = true, sp = muted })

      -- Treesitter
      hi(0, "@variable",              { fg = fg })
      hi(0, "@variable.builtin",      { fg = red })
      hi(0, "@variable.parameter",    { fg = fg })
      hi(0, "@variable.member",       { fg = fg })
      hi(0, "@constant",              { fg = gold })
      hi(0, "@constant.builtin",      { fg = red })
      hi(0, "@string",                { fg = cyan })
      hi(0, "@string.escape",         { fg = gold })
      hi(0, "@character",             { fg = cyan })
      hi(0, "@number",                { fg = gold })
      hi(0, "@boolean",               { fg = red })
      hi(0, "@float",                 { fg = gold })
      hi(0, "@function",              { fg = cyan })
      hi(0, "@function.builtin",      { fg = red })
      hi(0, "@function.call",         { fg = cyan })
      hi(0, "@function.method",       { fg = cyan })
      hi(0, "@function.method.call",  { fg = cyan })
      hi(0, "@constructor",           { fg = cyan })
      hi(0, "@keyword",               { fg = purple })
      hi(0, "@keyword.function",      { fg = purple })
      hi(0, "@keyword.operator",      { fg = fg })
      hi(0, "@keyword.return",        { fg = purple })
      hi(0, "@keyword.import",        { fg = purple })
      hi(0, "@conditional",           { fg = purple })
      hi(0, "@repeat",                { fg = purple })
      hi(0, "@type",                  { fg = purple })
      hi(0, "@type.builtin",          { fg = purple })
      hi(0, "@attribute",             { fg = gold })
      hi(0, "@field",                 { fg = fg })
      hi(0, "@property",              { fg = fg })
      hi(0, "@namespace",             { fg = fg })
      hi(0, "@include",               { fg = purple })
      hi(0, "@comment",               { fg = muted, italic = true })
      hi(0, "@punctuation",           { fg = fg })
      hi(0, "@punctuation.bracket",   { fg = muted })
      hi(0, "@punctuation.delimiter", { fg = muted })
      hi(0, "@operator",              { fg = fg })
      hi(0, "@tag",                   { fg = red })
      hi(0, "@tag.attribute",         { fg = fg })
      hi(0, "@tag.delimiter",         { fg = muted })
    '';
    "nvim/lua/plugins/treesitter.lua".source = ./lua/plugins/treesitter.lua;
  };
}
