local u = require("utils")
local g = vim.g

local opt = vim.opt
local cmd = vim.cmd


-- Theme-agnostic setup
function my_highlights_all()

   -- Transparent background, including signcolumn and foldcolumn, but not linenr
    u.Hi("Normal", { guibg="NONE", ctermbg="NONE" })
    u.Hi("SignColumn", { guibg="NONE", ctermbg="NONE" })
    u.Hi("FoldColumn", { guibg="NONE", ctermbg="NONE" })
end


-- Nord-specific setup
local nord0 = "#2E3440"
local nord1 = "#3B4252"
local nord2 = "#434C5E"
local nord3 = "#4C566A"
local nord3_bright = "#616E88"
local nord4 = "#D8DEE9"
local nord5 = "#E5E9F0"
local nord6 = "#ECEFF4"
local nord7 = "#8FBCBB"
local nord8 = "#88C0D0"
local nord9 = "#81A1C1"
local nord10 = "#5E81AC"
local nord11 = "#BF616A"
local nord12 = "#D08770"
local nord13 = "#EBCB8B"
local nord14 = "#A3BE8C"
local nord15 = "#B48EAD"

-- Diagnostic signature colours
local error_fg = nord11
local warning_fg = nord13
local information_fg = nord8
local hint_fg = nord9
local ok_fg = nord14

local statusline_active_fg = "#9DA6B9"  -- halfway between nord3_bright and nord4
local statusline_active_bg = nord1


function my_highlights_nord()

    -- (poor readability of some u.Highlight groups)
    -- (Stock fg was: guifg=nord3_gui, ctermfg=nord3_term)
    u.Hi("SpecialKey", { guifg=nord3_bright, ctermfg=8 })

    -- (Stock fg was: guifg=nord2_gui, gui=bold, ctermfg=nord3_term)
    u.Hi("NonText", { guifg=nord10, gui="NONE", ctermfg=5 })

    -- (Pmenu: stock BG was: guibg=nord2_gui, ctermbg=nord1_term)
    u.Hi("Pmenu", { guibg=nord3, ctermbg=8 })

    -- (Pmenu: stock BG was: guibg=nord3_gui, ctermbg=nord3_term)
    u.Hi("PmenuThumb", { guibg="#66738e", ctermbg=8 })

    -- QuickFix list's line numbers are unreadable
    u.Hi("qfFileName", { guifg=nord10 })
    u.Hi("qfLineNr", { guifg=nord8 })
    u.Hi("QuickFixLine", { guibg=nord7, guifg="Black" })

    -- Active statusbar: override 'StatusLine' u.Highlight with Nord-ish colours
    u.Hi("StatusLine", { guifg=statusline_active_fg, guibg=statusline_active_bg })

    u.Hi("StatusLineError", { guifg=error_fg, guibg=statusline_active_bg })
    u.Hi("StatusLineWarning", { guifg=warning_fg, guibg=statusline_active_bg })
    u.Hi("StatusLineInformation", { guifg=information_fg, guibg=statusline_active_bg })
    u.Hi("StatusLineHint", { guifg=hint_fg, guibg=statusline_active_bg })
    u.Hi("StatusLineOk", { guifg=ok_fg, guibg=statusline_active_bg })

    -- Inactive statusbars: make a thin rule
    u.HiClear("StatusLineNC")
    u.Hi("StatusLineNC", { gui="underline", guifg=nord3_bright })

    -- Line numbers: tweaks to show current line
    u.HiClear("CursorLine")
    u.HiClear("CursorLineNr")
    u.HiLink("CursorLineNr", "Bold", true)

    -- LSP diagnostics: line number backgrounds and foregrounds
    --('black' is #667084; bg colours are a blend)
    u.Hi("LspDiagnosticsDefaultError", { guifg=error_fg})
    u.Hi("LspDiagnosticsDefaultWarning", { guifg=warning_fg})
    u.Hi("LspDiagnosticsDefaultInformation", { guifg=information_fg })
    u.Hi("LspDiagnosticsDefaultHint", { guifg=hint_fg })

    u.Hi("LspDiagnosticsUnderlineError", { guifg=error_fg, gui="underline" })
    u.Hi("LspDiagnosticsUnderlineWarning", { guifg=warning_fg, gui="underline" })
    u.Hi("LspDiagnosticsUnderlineInformation", { guifg=information_fg, gui="underline" })
    u.Hi("LspDiagnosticsUnderlineHint", { guifg=hint_fg, gui="underline" })

    u.Hi("LspDiagnosticsVirtualTextError", { guifg="#5C4C58", gui="italic" })
    u.Hi("LspDiagnosticsVirtualTextWarning", { guifg="#4F4B4C ", gui="italic" })
    u.Hi("LspDiagnosticsVirtualTextInformation", { guifg="#505D6D", gui="italic" })
    u.Hi("LspDiagnosticsVirtualTextHint", { guifg="#485165", gui="italic" })

    u.HiLink("LspDiagnosticsError", "LspDiagnosticsDefaultError", true)
    u.HiLink("LspDiagnosticsWarning", "LspDiagnosticsDefaultWarning", true)
    u.HiLink("LspDiagnosticsInformation", "LspDiagnosticsDefaultInformation", true)
    u.HiLink("LspDiagnosticsHint", "LspDiagnosticsDefaultHint", true)

    u.HiLink("LspDiagnosticsLineNrError", "LspDiagnosticsDefaultError", true)
    u.HiLink("LspDiagnosticsLineNrWarning", "LspDiagnosticsDefaultWarning", true)
    u.HiLink("LspDiagnosticsLineNrInformation", "LspDiagnosticsDefaultInformation", true)
    u.HiLink("LspDiagnosticsLineNrHint", "LspDiagnosticsDefaultHint", true)

    u.Hi("LspReferenceRead", { guifg=nord14, gui="bold,underline" })
    u.Hi("LspReferenceText", { guifg=nord10, gui="bold,underline" })
    u.Hi("LspReferenceWrite", { guifg=nord15, gui="bold,underline" })

    -- Folds
    u.Hi("Folded", { guifg=nord7, gui="italic" })

    -- Git gutter signs
    u.Hi("GitSignsAdd", { guifg=nord9 })
    u.Hi("GitSignsChange", { guifg=nord3 })
    u.Hi("GitSignsDelete", { gui="bold", guifg=nord11 })
    u.Hi("GitSignsChangeDelete", { gui="bold", guifg=nord11 })

    -- Telescope (lifted from FZF Nord theme)
    u.Hi("TelescopeSelection", { gui="bold" })
    u.Hi("TelescopeSelectionCaret", { guifg=nord13, gui="bold" })
    u.Hi("TelescopeMultiSelection", { guifg=nord14 })
    u.Hi("TelescopeMatching", { guifg=nord9 })
    u.Hi("TelescopePromptPrefix", { guifg="#bf6069" })
    u.Hi("TelescopeBorder", { guifg=nord3_bright })

    -- nvim-tree
    u.Hi("NvimTreeNormal", { guifg=nord4 })
    u.Hi("NvimTreeIndentMarker", { guifg=nord1 })

    u.Hi("NvimTreeFolderIcon", { guifg=nord3_bright })
    u.HiLink("NvimTreeFolderName", "NvimTreeNormal", true)

    u.HiLink("NvimTreeOpenedFolderIcon", "NvimTreeFolderIcon", true)
    u.HiLink("NvimTreeOpenedFolderName", "NvimTreeNormal", true)

    u.HiLink("NvimTreeEmptyFolderIcon", "NvimTreeFolderIcon", true)
    u.HiLink("NvimTreeEmptyFolderName", "NvimTreeFolderIcon", true)

    -- Suppress overly-aggressive error u.Highlighting under Treesitter
    u.HiClear("TSError")

    u.Hi("markdownUrl", { gui="underline", cterm="underline" })
    vim.cmd[[ match Todo /TODO/ ]]
end


-- NOTE!  Theme config, e.g. lets, _must_ precede the 'colorscheme' cmd to work
vim.api.nvim_exec([[
augroup ColorSchemeOverrides
  autocmd!
  autocmd ColorScheme *    luado my_highlights_all()
  autocmd ColorScheme nord luado my_highlights_nord()
augroup END
]], false)


-- Nord-specific propertis that must be set _before_ colourscheme is applied
g.nord_italic = 1
g.nord_italic_comments = 1
g.nord_underline = 1
g.nord_cursor_line_number_background = 1


-- NOW apply the colorscheme.
vim.cmd[[colorscheme nord]]

