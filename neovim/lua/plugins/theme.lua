-- Bail early, because Packer loads configs, regardless of disabled flag.
if require("pluginsEnabled").plugin_status.nord == false then
    return
end

local u = require "utils"
local g = vim.g

local opt = vim.opt
local cmd = vim.cmd

-- Theme-agnostic setup
function my_highlights_all()
    -- Transparent background, including signcolumn and foldcolumn, but not linenr
    u.Hi("Normal", { guibg = "NONE", ctermbg = "NONE" })
    u.Hi("SignColumn", { guibg = "NONE", ctermbg = "NONE" })
    u.Hi("FoldColumn", { guibg = "NONE", ctermbg = "NONE" })
    u.Hi("VertSplit", { guibg = "NONE", ctermbg = "NONE" })

    -- To get undercurl working nicely
    u.Hi("SpellBad", { guifg = "NONE", guibg = "NONE" })
    u.Hi("SpellCap", { guifg = "NONE", guibg = "NONE" })
    u.Hi("SpellLocal", { guifg = "NONE", guibg = "NONE" })
    u.Hi("SpellRare", { guifg = "NONE", guibg = "NONE" })
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
local warn_fg = nord13
local info_fg = nord8
local hint_fg = nord9
local ok_fg = nord14

local statusline_active_fg = "#9DA6B9" -- halfway between nord3_bright and nord4
local statusline_active_bg = nord1

function my_highlights_nord()
    -- (poor readability of some u.Highlight groups)
    -- (Stock fg was: guifg=nord3_gui, ctermfg=nord3_term)
    u.Hi("SpecialKey", { guifg = nord3_bright, ctermfg = 8 })

    -- (Stock fg was: guifg=nord2_gui, gui=bold, ctermfg=nord3_term)
    u.Hi("NonText", { guifg = nord10, gui = "NONE", ctermfg = 5 })

    -- (Pmenu: stock BG was: guibg=nord2_gui, ctermbg=nord1_term)
    u.Hi("Pmenu", { guibg = nord2, ctermbg = 8 })

    -- (Pmenu: stock BG was: guibg=nord3_gui, ctermbg=nord3_term)
    u.Hi("PmenuThumb", { guibg = nord3_bright, ctermbg = 8 })

    u.Hi("PmenuSel", { guibg = nord8, guifg = nord1, gui = "NONE" })

    -- (nvim-cmp's custom-drawn autocompletion menu)
    u.Hi("CmpItemAbbr", { guifg = nord5 })
    u.Hi("CmpItemAbbrDeprecated", { guifg = nord4 })
    u.Hi("CmpItemAbbrMatch", { guifg = nord8 })
    u.Hi("CmpItemAbbrMatchFuzzy", { guifg = nord12 })
    u.Hi("CmpItemKind", { guifg = nord15 })
    u.Hi("CmpItemMenu", { guifg = nord3_bright })

    -- QuickFix list's line numbers are unreadable
    u.Hi("qfFileName", { guifg = nord10 })
    u.Hi("qfLineNr", { guifg = nord8 })
    u.Hi("QuickFixLine", { guibg = nord7, guifg = "Black" })

    -- Active statusbar: override 'StatusLine' u.Highlight with Nord-ish colours
    u.Hi("StatusLine", { guifg = statusline_active_fg, guibg = statusline_active_bg })

    u.Hi("StatusLineError", { guifg = error_fg, guibg = statusline_active_bg })
    u.Hi("StatusLineWarn", { guifg = warn_fg, guibg = statusline_active_bg })
    u.Hi("StatusLineInfo", { guifg = info_fg, guibg = statusline_active_bg })
    u.Hi("StatusLineHint", { guifg = hint_fg, guibg = statusline_active_bg })
    u.Hi("StatusLineOk", { guifg = ok_fg, guibg = statusline_active_bg })

    -- Inactive statusbars: make a thin rule; align VertSplit to match.
    u.HiClear "StatusLineNC"
    u.Hi("StatusLineNC", { gui = "underline", guifg = nord3_bright })
    u.Hi("VertSplit", { guibg = "NONE", ctermbg = "NONE", guifg = nord3_bright })

    -- Line numbers: tweaks to show current line
    u.HiClear "CursorLine"
    u.HiClear "CursorLineNr"
    u.HiLink("CursorLineNr", "Bold", true)

    -- LSP diagnostics: line number backgrounds and foregrounds
    --('black' is #667084; bg colours are a blend)
    u.Hi("DiagnosticError", { guifg = error_fg })
    u.Hi("DiagnosticWarn", { guifg = warn_fg })
    u.Hi("DiagnosticInfo", { guifg = info_fg })
    u.Hi("DiagnosticHint", { guifg = hint_fg })

    u.Hi("DiagnosticVirtualTextError", { guifg = error_fg, guibg="#5C4C58", gui="italic" })
    u.Hi("DiagnosticVirtualTextWarn", { guifg = warn_fg, guibg="#4F4B4C ", gui="italic" })
    u.Hi("DiagnosticVirtualTextInfo", { guifg = info_fg, guibg="#505D6D", gui="italic" })
    u.Hi("DiagnosticVirtualTextHint", { guifg = hint_fg, guibg="#485165", gui="italic" })

    u.Hi("DiagnosticUnderlineError", { guifg = "NONE", guisp = error_fg, gui = "undercurl" })
    u.Hi("DiagnosticUnderlineWarn", { guifg = "NONE", guisp = warn_fg, gui = "undercurl" })
    u.Hi("DiagnosticUnderlineInfo", { guifg = "NONE", guisp = info_fg, gui = "undercurl" })
    u.Hi("DiagnosticUnderlineHint", { guifg = "NONE", guisp = hint_fg, gui = "undercurl" })

    u.HiLink("DiagnosticLineNrError", "DiagnosticError", true)
    u.HiLink("DiagnosticLineNrWarn", "DiagnosticWarn", true)
    u.HiLink("DiagnosticLineNrInfo", "DiagnosticInfo", true)
    u.HiLink("DiagnosticLineNrHint", "DiagnosticHint", true)

    u.HiLink("DiagnosticSignError", "DiagnosticError", true)
    u.HiLink("DiagnosticSignWarn", "DiagnosticWarn", true)
    u.HiLink("DiagnosticSignInfo", "DiagnosticInfo", true)
    u.HiLink("DiagnosticSignHint", "DiagnosticHint", true)

    u.Hi("LspReferenceRead", { guifg = nord14, gui = "bold,underline" })
    u.Hi("LspReferenceWrite", { guifg = nord15, gui = "bold,underline" })
    u.Hi("LspReferenceText", { gui = "bold" })

    -- Folds
    u.Hi("Folded", { guifg = nord7, gui = "italic" })

    -- Git gutter signs
    u.Hi("GitSignsAdd", { guifg = nord9 })
    u.Hi("GitSignsChange", { guifg = nord13 })
    u.Hi("GitSignsDelete", { gui = "bold", guifg = nord11 })
    u.Hi("GitSignsChangeDelete", { gui = "bold", guifg = nord11 })

    -- Telescope (lifted from FZF Nord theme)
    u.Hi("TelescopeSelection", { gui = "bold" })
    u.Hi("TelescopeSelectionCaret", { guifg = nord13, gui = "bold" })
    u.Hi("TelescopeMultiSelection", { guifg = nord14 })
    u.Hi("TelescopeMatching", { guifg = nord9 })
    u.Hi("TelescopePromptPrefix", { guifg = "#bf6069" })
    u.Hi("TelescopeBorder", { guifg = nord3_bright })

    -- fzf.  These feed FZF_COLORS.  They are _meant_ to be populated from
    -- existing highlight groups, but I am using 'Nord' colours which look
    -- better than the stock colors.

    -- stylua: ignore start
    u.Hi("FzfFg",      { guifg = "#e5e9f0", guibg=nord3 })
    u.Hi("FzfBg",      { guibg = "#2e3440" })
    u.Hi("FzfHl",      { guifg = "#81a1c1", guibg=nord3 })

    u.Hi("FzfFg_",     { guifg = "#e5e9f0", gui="bold", guibg=nord1 })
    u.Hi("FzfBg_",     {                    gui="bold", guibg=nord1 })
    u.Hi("FzfHl_",     { guifg = "#81a1c1", gui="bold", guibg=nord1 })

    u.Hi("FzfInfo",    { guifg = "#eacb8a" })
    u.Hi("FzfBorder",  { guifg = "#616E88" })
    u.Hi("FzfPrompt",  { guifg = "#bf6069" })
    u.Hi("FzfPointer", { guifg = "#b48dac" })
    u.Hi("FzfMarker",  { guifg = "#a3be8b" })
    u.Hi("FzfSpinner", { guifg = "#b48dac" })
    u.Hi("FzfHeader",  { guifg = "#a3be8b" })
    -- stylua: ignore end

    -- nvim-tree
    u.Hi("NvimTreeNormal", { guifg = nord4 })
    u.Hi("NvimTreeIndentMarker", { guifg = nord1 })

    u.Hi("NvimTreeFolderIcon", { guifg = nord3_bright })
    u.HiLink("NvimTreeFolderName", "NvimTreeNormal", true)

    u.HiLink("NvimTreeOpenedFolderIcon", "NvimTreeFolderIcon", true)
    u.HiLink("NvimTreeOpenedFolderName", "NvimTreeNormal", true)

    u.HiLink("NvimTreeEmptyFolderIcon", "NvimTreeFolderIcon", true)
    u.HiLink("NvimTreeEmptyFolderName", "NvimTreeFolderIcon", true)

    -- Latex tweaks
    u.Hi("texCmdEnv", { guifg = nord15, gui = "bold" })
    u.Hi("texCmdEnvM", { guifg = nord7, gui = "bold" })
    u.Hi("texDelim", { guifg = nord3 })
    u.Hi("texMathDelim", { guifg = nord10, gui = "bold" })
    u.Hi("texMathTextConcArg", { guifg = nord3_bright, gui = "italic" })
    u.Hi("texSICmd", { guifg = nord14 })

    -- Suppress overly-aggressive error u.Highlighting under Treesitter
    u.HiClear "TSError"

    u.Hi("markdownUrl", { gui = "underline", cterm = "underline" })
end

-- NOTE!  Theme config, e.g. lets, _must_ precede the 'colorscheme' cmd to work
-- stylua: ignore
vim.api.nvim_exec( [[
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

g.python_multiline_string_as_comment = 1 -- Python's stock (non-TS) highlighting definition

-- NOW apply the colorscheme.
vim.cmd [[ colorscheme nord ]]
