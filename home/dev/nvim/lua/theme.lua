-- Tokyo Night palette
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
hl("Normal",     { fg = c.fg,      bg = c.bg      })
hl("CursorLine", { bg = "#292e42"                 })
hl("Visual",     { bg = "#283457"                 })
hl("Search",     { fg = c.bg,      bg = c.yellow  })
hl("IncSearch",  { fg = c.bg,      bg = c.orange  })
hl("LineNr",     { fg = "#3b4261"                 })

-- Syntax
hl("Comment",    { fg = c.comment, italic = true  })
hl("Constant",   { fg = c.orange                  })
hl("String",     { fg = c.green                   })
hl("Identifier", { fg = c.red                     })
hl("Function",   { fg = c.cyan                    })
hl("Statement",  { fg = c.purple                  })
hl("PreProc",    { fg = c.cyan                    })
hl("Type",       { fg = c.yellow                  })
hl("Special",    { fg = c.purple                  })
hl("Underlined", { underline = true               })
hl("Error",      { fg = c.red,     bold = true    })
hl("Todo",       { fg = c.bg,      bg = c.cyan,   bold = true })

-- LSP diagnostics
hl("DiagnosticError", { fg = c.red    })
hl("DiagnosticWarn",  { fg = c.yellow })
hl("DiagnosticInfo",  { fg = c.cyan   })
hl("DiagnosticHint",  { fg = c.purple })

-- Completion menu
hl("Pmenu",    { bg = c.bg_dark, fg = c.fg    })
hl("PmenuSel", { bg = "#3b4261", bold = true  })
