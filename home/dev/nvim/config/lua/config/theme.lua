local c = require("generated.colors").colors

local function hi(group, opts) vim.api.nvim_set_hl(0, group, opts) end

vim.cmd("hi clear")
vim.o.background = "dark"

-- Base
hi("Normal",       { fg = c.text,       bg = c.background })
hi("NormalFloat",  { fg = c.text,       bg = c.surface })
hi("NormalNC",     { fg = c.subtle,     bg = c.background })

-- UI chrome
hi("StatusLine",   { fg = c.text,       bg = c.surface })
hi("StatusLineNC", { fg = c.subtle,     bg = c.surface })
hi("WinSeparator", { fg = c.surface })
hi("TabLine",      { fg = c.subtle,     bg = c.surface })
hi("TabLineSel",   { fg = c.text,       bg = c.background })
hi("TabLineFill",  { bg = c.surface })

-- Line numbers / gutter
hi("LineNr",       { fg = c.subtle })
hi("CursorLine",   { bg = c.surface })
hi("CursorLineNr", { fg = c.accent,     bold = true })
hi("SignColumn",   { bg = c.background })

-- Selection / search
hi("Visual",       { bg = c.surface })
hi("Search",       { fg = c.background, bg = c.highlight })
hi("IncSearch",    { fg = c.background, bg = c.accent })
hi("CurSearch",    { fg = c.background, bg = c.accent })

-- Completion menu
hi("Pmenu",        { fg = c.text,       bg = c.surface })
hi("PmenuSel",     { fg = c.background, bg = c.secondary })
hi("PmenuBorder",  { fg = c.subtle,     bg = c.surface })

-- Diagnostics
hi("DiagnosticError",       { fg = c.urgent })
hi("DiagnosticWarn",        { fg = c.highlight })
hi("DiagnosticInfo",        { fg = c.blue })
hi("DiagnosticHint",        { fg = c.subtle })
hi("DiagnosticUnderlineError", { undercurl = true, sp = c.urgent })
hi("DiagnosticUnderlineWarn",  { undercurl = true, sp = c.highlight })

-- Syntax
hi("Comment",    { fg = c.subtle,     italic = true })
hi("Keyword",    { fg = c.accent,     bold = true })
hi("Function",   { fg = c.secondary })
hi("String",     { fg = c.green })
hi("Number",     { fg = c.cyan })
hi("Boolean",    { fg = c.cyan })
hi("Operator",   { fg = c.text })
hi("Type",       { fg = c.blue })
hi("Identifier", { fg = c.text })
hi("Constant",   { fg = c.cyan })
hi("Special",    { fg = c.accent })
hi("PreProc",    { fg = c.magenta })
hi("Todo",       { fg = c.background, bg = c.highlight, bold = true })

-- Treesitter (inherits via links where possible)
hi("@keyword",           { link = "Keyword" })
hi("@function",          { link = "Function" })
hi("@function.builtin",  { fg = c.cyan })
hi("@string",            { link = "String" })
hi("@number",            { link = "Number" })
hi("@boolean",           { link = "Boolean" })
hi("@type",              { link = "Type" })
hi("@variable",          { fg = c.text })
hi("@parameter",         { fg = c.text,    italic = true })
hi("@comment",           { link = "Comment" })
hi("@constant",          { link = "Constant" })
hi("@punctuation",       { fg = c.subtle })
hi("@operator",          { link = "Operator" })
hi("@tag",               { fg = c.accent })
hi("@tag.attribute",     { fg = c.secondary })
hi("@tag.delimiter",     { fg = c.subtle })

-- LSP
hi("LspReferenceText",  { bg = c.surface })
hi("LspReferenceRead",  { bg = c.surface })
hi("LspReferenceWrite", { bg = c.surface, underline = true })
