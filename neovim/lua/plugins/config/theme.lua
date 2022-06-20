local u = require "utils"

-- Theme-agnostic setup
function my_highlights_all()
    -- Transparent background, including signcolumn and foldcolumn, but not linenr
    u.Hi("Normal", { guibg = "NONE", ctermbg = "NONE" })
    u.Hi("SignColumn", { guibg = "NONE", ctermbg = "NONE" })
    u.Hi("FoldColumn", { guibg = "NONE", ctermbg = "NONE" })
    u.Hi("CursorLineFold", { guibg = "NONE", ctermbg = "NONE" })
    u.Hi("VertSplit", { guibg = "NONE", ctermbg = "NONE" })

    -- Terminal supports undercurl and coloured underlines?
    if string.find(vim.env.TERM, "xterm-kitty", 1, true) ~= nil then
        u.Hi("SpellBad", { guifg = "NONE", guibg = "NONE", gui = "undercurl" })
        u.Hi("SpellCap", { guifg = "NONE", guibg = "NONE", gui = "undercurl" })
        u.Hi("SpellLocal", { guifg = "NONE", guibg = "NONE", gui = "undercurl" })
        u.Hi("SpellRare", { guifg = "NONE", guibg = "NONE", gui = "undercurl" })
    end
end

-- Adapted from shaunsingh/nord.nvim
local nord = (vim.o.background == "dark")
        and {
            --16 colors
            nord0 = "#2E3440", -- nord.nord0 in palette
            nord1 = "#3B4252", -- nord.nord1 in palette
            nord2 = "#434C5E", -- nord.nord2 in palette
            nord3 = "#4C566A", -- nord.nord3 in palette
            nord3_bright = "#616E88", -- out of palette
            nord4_dim = "#9DA6B9", -- out of palette
            nord4 = "#D8DEE9", -- nord.nord4 in palette
            nord5 = "#E5E9F0", -- nord.nord5 in palette
            nord6 = "#ECEFF4", -- nord.nord6 in palette
            nord7 = "#8FBCBB", -- nord.nord7 in palette
            nord8 = "#88C0D0", -- nord.nord8 in palette
            nord9 = "#81A1C1", -- nord.nord9 in palette
            nord10 = "#5E81AC", -- nord.nord10 in palette
            nord11 = "#BF616A", -- nord.nord11 in palette
            nord12 = "#D08770", -- nord.nord12 in palette
            nord13 = "#EBCB8B", -- nord.nord13 in palette
            nord14 = "#A3BE8C", -- nord.nord14 in palette
            nord15 = "#B48EAD", -- nord.nord15 in palette
            nord15_dim = "#A38DC9", -- off-palette lilac/purple variant
            none = "NONE",
        }
    or {
        --16 colors
        nord0 = "#ECEFF4", -- nord.nord6 in palette
        nord1 = "#E5E9F0", -- nord.nord5 in palette
        nord2 = "#D8DEE9", -- nord.nord4 in palette
        nord3 = "#4C566A", -- nord.nord3 in palette
        nord3_bright = "#AEC7DF", -- out of palette
        nord4_dim = "#798A9F", -- nord.nord2 in palette
        nord4 = "#434C5E", -- nord.nord2 in palette
        nord5 = "#3B4252", -- nord.nord1 in palette
        nord6 = "#2E3440", -- nord.nord0 in palette
        nord7 = "#8FBCBB", -- nord.nord7 in palette
        nord8 = "#88C0D0", -- nord.nord8 in palette
        nord9 = "#81A1C1", -- nord.nord9 in palette
        nord10 = "#5E81AC", -- nord.nord10 in palette
        nord11 = "#BF616A", -- nord.nord11 in palette
        nord12 = "#D08770", -- nord.nord12 in palette
        nord13 = "#EBCB8B", -- nord.nord13 in palette
        nord14 = "#A3BE8C", -- nord.nord14 in palette
        nord15 = "#B48EAD", -- nord.nord15 in palette
        nord15_dim = "#A38DC9", -- off-palette lilac/purple variant
        none = "NONE",
    }

local M = {}
M.colors = {
    cyan = nord.nord7,
    blue = nord.nord10,
    lightblue = nord.nord8,
    red = nord.nord11,
    orange = nord.nord12,
    yellow = nord.nord13,
    green = nord.nord14,
    pink = nord.nord15,
    magenta = nord.nord15,
}

-- Diagnostic signature colours
local error_fg = nord.nord11
local warn_fg = nord.nord13
local info_fg = nord.nord9
local hint_fg = nord.nord7
local misc_fg = nord.nord15
local misc2_fg = nord.nord15_dim
local ok_fg = nord.nord14

local diff_add = nord.nord14
local diff_change = nord.nord13
local diff_delete = nord.nord11

local spell_bad_fg = error_fg
local spell_cap_fg = warn_fg
local spell_rare_fg = info_fg
local spell_local_fg = misc_fg

local statusline_active_fg = nord.nord4_dim -- halfway between nord3_bright and nord4
local statusline_active_bg = nord.nord1

function my_highlights_nord()
    -- (poor readability of some u.Highlight groups)
    -- (Stock fg was: guifg = nord3_gui, ctermfg=nord3_term)
    u.Hi("SpecialKey", { guifg = nord.nord3_bright, ctermfg = 8 })

    -- (Stock fg was: guifg = nord2_gui, gui=bold, ctermfg=nord3_term)
    u.Hi("NonText", { guifg = nord.nord10, gui = "NONE", ctermfg = 5 })

    -- (Pmenu: stock BG was: guibg=nord2_gui, ctermbg=nord1_term)
    u.Hi("Pmenu", { guibg = nord.nord2, ctermbg = 8 })

    -- (Pmenu: stock BG was: guibg=nord3_gui, ctermbg=nord3_term)
    u.Hi("PmenuThumb", { guibg = nord.nord3_bright, ctermbg = 8 })

    u.Hi("PmenuSel", { guibg = nord.nord8, guifg = nord.nord1, gui = "NONE" })

    -- (nvim-cmp's custom-drawn autocompletion menu)
    u.Hi("CmpItemAbbr", { guifg = nord.nord5 })
    u.Hi("CmpItemAbbrDeprecated", { guifg = nord.nord4, gui = "strikethrough" })
    u.Hi("CmpItemAbbrMatch", { guifg = nord.nord9 })
    u.Hi("CmpItemAbbrMatchFuzzy", { guifg = nord.nord12 })
    u.Hi("CmpItemKind", { guifg = nord.nord15 })
    u.Hi("CmpItemMenu", { guifg = nord.nord3_bright })

    -- (VS Code-like highlighting of kinds)
    -- light blue
    u.Hi("CmpItemKindVariable", { guifg = "#9CDCFE" })
    u.Hi("CmpItemKindInterface", { guifg = "#9CDCFE" })
    u.Hi("CmpItemKindText", { guifg = "#9CDCFE" })
    u.Hi("CmpItemKindText", { guifg = "#9CDCFE" })
    -- pink
    u.Hi("CmpItemKindFunction", { guifg = "#C586C0" })
    u.Hi("CmpItemKindMethod", { guifg = "#C586C0" })
    -- front
    u.Hi("CmpItemKindKeyword", { guifg = "#D4D4D4" })
    u.Hi("CmpItemKindProperty", { guifg = "#D4D4D4" })
    u.Hi("CmpItemKindUnit", { guifg = "#D4D4D4" })

    u.Hi("CmpGhostText", { guifg = nord.nord12 })

    -- QuickFix list's line numbers are unreadable
    u.Hi("qfFileName", { guifg = nord.nord10 })
    u.Hi("qfLineNr", { guifg = nord.nord8 })
    u.Hi("QuickFixLine", { guibg = nord.nord7, guifg = "Black" })

    u.Hi("MatchParen", { guifg = nord.nord12, gui="bold", guibg = "NONE" })

    -- Active statusbar: override 'StatusLine' u.Highlight with Nord-ish colours
    u.Hi("StatusLine", { guifg = statusline_active_fg, guibg = statusline_active_bg })

    u.Hi("StatusLineError", { guifg = error_fg, guibg = statusline_active_bg })
    u.Hi("StatusLineWarn", { guifg = warn_fg, guibg = statusline_active_bg })
    u.Hi("StatusLineInfo", { guifg = info_fg, guibg = statusline_active_bg })
    u.Hi("StatusLineHint", { guifg = hint_fg, guibg = statusline_active_bg })
    u.Hi("StatusLineOk", { guifg = ok_fg, guibg = statusline_active_bg })
    u.Hi("StatusLineAdd", { guifg = diff_add, guibg = statusline_active_bg })
    u.Hi("StatusLineChange", { guifg = diff_change, guibg = statusline_active_bg })
    u.Hi("StatusLineDelete", { guifg = diff_delete, gui = "bold", guibg = statusline_active_bg })

    u.Hi("StatusLineModeNormal", { guifg = statusline_active_fg, gui = "bold", guibg = statusline_active_bg })
    u.Hi("StatusLineModeInsert", { guifg = nord.nord8, gui = "bold", guibg = statusline_active_bg })
    u.Hi("StatusLineModeVisual", { guifg = nord.nord13, gui = "bold", guibg = statusline_active_bg })
    u.Hi("StatusLineModeReplace", { guifg = nord.nord12, gui = "bold", guibg = statusline_active_bg })
    u.Hi("StatusLineModeCommand", { guifg = nord.nord7, gui = "bold", guibg = statusline_active_bg })
    u.Hi("StatusLineModeTerminal", { guifg = nord.nord14, gui = "bold", guibg = statusline_active_bg })
    u.Hi("StatusLineModeEx", { guifg = nord.nord12, gui = "bold", guibg = statusline_active_bg })

    -- Inactive statusbars: make a thin rule; align VertSplit to match.
    u.HiClear "StatusLineNC"
    u.Hi("StatusLineNC", { gui = "underline", guifg = nord.nord3 })
    u.Hi("VertSplit", { guibg = "NONE", ctermbg = "NONE", guifg = nord.nord3 })

    -- Line numbers: tweaks to show current line
    u.HiClear "CursorLineNr"
    u.HiLink("CursorLineNr", "Bold", true)

    -- Message area
    u.Hi("MsgArea", { guifg = statusline_active_fg })
    u.Hi("ErrorMsg", { guifg = error_fg, guibg = "NONE" })
    u.Hi("WarningMsg", { guifg = warn_fg, guibg = "NONE" })

    -- Winbar
    u.Hi("WinBar", { guifg = statusline_active_fg, gui = "italic" })

    u.Hi("ErrorWinbarDiagIndic", { guifg = error_fg })
    u.Hi("WarnWinbarDiagIndic", { guifg = warn_fg })
    u.Hi("InfoWinbarDiagIndic", { guifg = info_fg })
    u.Hi("HintWinbarDiagIndic", { guifg = hint_fg })
    u.Hi("OkWinbarDiagIndic", { guifg = ok_fg })

    -- LSP diagnostics: line number backgrounds and foregrounds
    --('black' is #667084; bg colours are a blend)
    u.Hi("DiagnosticError", { guifg = error_fg })
    u.Hi("DiagnosticWarn", { guifg = warn_fg })
    u.Hi("DiagnosticInfo", { guifg = info_fg })
    u.Hi("DiagnosticHint", { guifg = hint_fg })

    u.Hi("DiagnosticVirtualTextError", { guifg = error_fg, gui = "italic" })
    u.Hi("DiagnosticVirtualTextWarn", { guifg = warn_fg, gui = "italic" })
    u.Hi("DiagnosticVirtualTextInfo", { guifg = info_fg, gui = "italic" })
    u.Hi("DiagnosticVirtualTextHint", { guifg = hint_fg, gui = "italic" })

    -- Are we running 'kitty' and support undercurl and coloured underlines?
    if string.find(vim.env.TERM, "xterm-kitty", 1, true) ~= nil then
        u.Hi("DiagnosticUnderlineError", { guifg = "NONE", guibg = "NONE", guisp = error_fg, gui = "undercurl" })
        u.Hi("DiagnosticUnderlineWarn", { guifg = "NONE", guibg = "NONE", guisp = warn_fg, gui = "undercurl" })
        u.Hi("DiagnosticUnderlineInfo", { guifg = "NONE", guibg = "NONE", guisp = info_fg, gui = "undercurl" })
        u.Hi("DiagnosticUnderlineHint", { guifg = "NONE", guibg = "NONE", guisp = hint_fg, gui = "undercurl" })

        -- Tweak undercurl colour with Nord colours
        u.Hi("SpellBad", { guisp = spell_bad_fg })
        u.Hi("SpellCap", { guisp = spell_cap_fg })
        u.Hi("SpellLocal", { guisp = spell_local_fg })
        u.Hi("SpellRare", { guisp = spell_rare_fg })
    else
        u.Hi("DiagnosticUnderlineError", { guifg = error_fg, guibg = "NONE", gui = "underline" })
        u.Hi("DiagnosticUnderlineWarn", { guifg = warn_fg, guibg = "NONE", gui = "underline" })
        u.Hi("DiagnosticUnderlineInfo", { guifg = info_fg, guibg = "NONE", gui = "underline" })
        u.Hi("DiagnosticUnderlineHint", { guifg = hint_fg, guibg = "NONE", gui = "underline" })
    end

    u.HiLink("DiagnosticLineNrError", "DiagnosticError", true)
    u.HiLink("DiagnosticLineNrWarn", "DiagnosticWarn", true)
    u.HiLink("DiagnosticLineNrInfo", "DiagnosticInfo", true)
    u.HiLink("DiagnosticLineNrHint", "DiagnosticHint", true)

    u.HiLink("DiagnosticFloatingError", "DiagnosticError", true)
    u.HiLink("DiagnosticFloatingWarn", "DiagnosticWarn", true)
    u.HiLink("DiagnosticFloatingInfo", "DiagnosticInfo", true)
    u.HiLink("DiagnosticFloatingHint", "DiagnosticHint", true)

    u.HiLink("DiagnosticSignError", "DiagnosticError", true)
    u.HiLink("DiagnosticSignWarn", "DiagnosticWarn", true)
    u.HiLink("DiagnosticSignInfo", "DiagnosticInfo", true)
    u.HiLink("DiagnosticSignHint", "DiagnosticHint", true)

    u.Hi("LspReferenceRead", { guifg = nord.nord14, guibg = nord.nord2, gui = "bold" })
    u.Hi("LspReferenceWrite", { guifg = nord.nord15, guibg = nord.nord2, gui = "bold" })
    u.Hi("LspReferenceText", { guibg = nord.nord1, gui = "none" })

    -- LSP CodeLenses (rendered as virtual text)
    u.Hi("LspCodeLens", { guifg = misc2_fg, gui = "italic" })
    u.HiLink("LspCodeLensSeparator", "Comment")

    -- Luasnip
    u.Hi("LuasnipChoiceNodeVirtualText", { guifg = nord.nord12 })
    u.Hi("LuasnipInsertNodeVirtualText", { guifg = nord.nord8 })

    -- Fold indicators
    u.Hi("FoldColumn", { guifg = nord.nord3_bright })
    u.Hi("CursorLineFold", { guifg = nord.nord4_dim })

    -- Git gutter signs
    local diff_add_dim_20 = "#829870"
    local diff_change_dim_10 = "#d3b67d"
    u.Hi("GitSignsAdd", { gui = "bold", guifg = diff_add_dim_20 })
    u.Hi("GitSignsChange", { guifg = diff_change_dim_10 })
    u.Hi("GitSignsDelete", { gui = "bold", guifg = diff_delete })
    u.Hi("GitSignsChangeDelete", { gui = "bold", guifg = nord.nord11 })

    -- Telescope (lifted from FZF Nord theme)
    u.Hi("TelescopeSelection", { gui = "bold" })
    u.Hi("TelescopeSelectionCaret", { guifg = nord.nord13, gui = "bold" })
    u.Hi("TelescopeMultiSelection", { guifg = nord.nord14 })
    u.Hi("TelescopeMatching", { guifg = nord.nord9 })
    u.Hi("TelescopePromptPrefix", { guifg = "#bf6069" })
    u.Hi("TelescopeBorder", { guifg = nord.nord3_bright })

    -- Floating info and rename/select popups (latter via stevearc/nvim-dressing)

    -- NOTE: for future use with 'smart' diag popups
    u.Hi("ErrorFloatBorder", { guifg = error_fg })
    u.Hi("WarnFloatBorder", { guifg = warn_fg })
    u.Hi("InfoFloatBorder", { guifg = info_fg })
    u.Hi("HintFloatBorder", { guifg = hint_fg })
    u.Hi("OkFloatBorder", { guifg = ok_fg })
    u.Hi("DimFloatBorder", { guifg = nord.nord3_bright })

    u.Hi("NormalFloat", { guibg = nord.nord0 })
    u.Hi("FloatTitle", { guifg = nord.nord4, gui = "bold" })
    u.HiLink("FloatBorder", "DimFloatBorder", true)

    -- ... popups that are informational are highlighted like info
    -- TODO: find way to attach these to LSP config
    u.HiLink("LspHoverFloatBorder", "InfoFloatBorder", true)
    u.HiLink("LspSignatureHelpFloatBorder", "InfoFloatBorder", true)

    -- ... popups that change stuff are highlighted like warnings
    u.HiLink("DressingFloatBorder", "WarnFloatBorder", true)

    -- ... nvim-cmp doc floats must be explicitly set
    u.HiLink("CmpDocFloatBorder", "DimFloatBorder", true)

    -- Indent guides
    u.Hi("IndentBlanklineChar", { guifg = nord.nord2 })
    u.Hi("IndentBlanklineContextChar", { guifg = nord.nord3_bright })

    -- nvim-notify
    u.Hi("NotifyDEBUGBorder", { guifg = nord.nord3 })
    u.Hi("NotifyDEBUGIcon", { guifg = nord.nord3 })
    u.Hi("NotifyDEBUGTitle", { guifg = nord.nord3 })
    u.Hi("NotifyERRORBorder", { guifg = nord.nord11 })
    u.Hi("NotifyERRORIcon", { guifg = nord.nord11 })
    u.Hi("NotifyERRORTitle", { guifg = nord.nord11 })
    u.Hi("NotifyINFOBorder", { guifg = nord.nord14 })
    u.Hi("NotifyINFOIcon", { guifg = nord.nord14 })
    u.Hi("NotifyINFOTitle", { guifg = nord.nord14 })
    u.Hi("NotifyTRACEBorder", { guifg = nord.nord15 })
    u.Hi("NotifyTRACEIcon", { guifg = nord.nord15 })
    u.Hi("NotifyTRACETitle", { guifg = nord.nord15 })
    u.Hi("NotifyWARNBorder", { guifg = nord.nord13 })
    u.Hi("NotifyWARNIcon", { guifg = nord.nord13 })
    u.Hi("NotifyWARNTitle", { guifg = nord.nord13 })


    -- fzf.  These feed FZF_COLORS.  They are _meant_ to be populated from
    -- existing highlight groups, but I am using 'Nord' colours which look
    -- better than the stock colors.
    --
    -- XXX: Use the FZF color picker:  https://minsw.github.io/fzf-color-picker/

    -- stylua: ignore start
    u.Hi("FzfFg",      { guifg = "#e5e9f0", guibg=nord.nord3 })
    u.Hi("FzfBg",      { guibg = "#2e3440" })
    u.Hi("FzfHl",      { guifg = "#81a1c1", guibg=nord.nord3 })

    u.Hi("FzfFg_",     { guifg = "#e5e9f0", gui="bold", guibg=nord.nord1 })
    u.Hi("FzfBg_",     {                    gui="bold", guibg=nord.nord1 })
    u.Hi("FzfHl_",     { guifg = "#81a1c1", gui="bold", guibg=nord.nord1 })

    u.Hi("FzfInfo",    { guifg = "#eacb8a" })
    u.Hi("FzfBorder",  { guifg = "#616E88" })
    u.Hi("FzfPrompt",  { guifg = "#bf6069" })
    u.Hi("FzfPointer", { guifg = "#b48dac" })
    u.Hi("FzfMarker",  { guifg = "#a3be8b" })
    u.Hi("FzfSpinner", { guifg = "#b48dac" })
    u.Hi("FzfHeader",  { guifg = "#a3be8b" })
    -- stylua: ignore end

    -- nvim-tree
    u.Hi("NvimTreeNormal", { guifg = nord.nord4 })
    u.Hi("NvimTreeOpenedFile", { gui = "bold" })

    u.Hi("NvimTreeIndentMarker", { guifg = nord.nord1 })

    u.Hi("NvimTreeFolderIcon", { guifg = nord.nord3_bright })
    u.HiLink("NvimTreeFolderName", "NvimTreeNormal", true)

    u.HiLink("NvimTreeOpenedFolderIcon", "NvimTreeFolderIcon", true)
    u.HiLink("NvimTreeOpenedFolderName", "NvimTreeNormal", true)

    u.HiLink("NvimTreeEmptyFolderIcon", "NvimTreeFolderIcon", true)
    u.HiLink("NvimTreeEmptyFolderName", "NvimTreeFolderIcon", true)

    -- Fidget: inlay LSP plugin status messages
    u.Hi("FidgetTitle", { gui = "bold", guifg = nord.nord15, guibg = nord.nord0 })
    u.Hi("FidgetTask", { guifg = nord.nord3_bright, guibg = nord.nord0 })

    -- Latex tweaks
    u.Hi("texCmdEnv", { guifg = nord.nord15, gui = "bold" })
    u.Hi("texCmdEnvM", { guifg = nord.nord7, gui = "bold" })
    u.Hi("texDelim", { guifg = nord.nord3 })
    u.Hi("texMathDelim", { guifg = nord.nord10, gui = "bold" })
    u.Hi("texMathTextConcArg", { guifg = nord.nord3_bright, gui = "italic" })
    u.Hi("texSICmd", { guifg = nord.nord14 })

    -- vim-easymotion
    local emTarget1 = "#d0505A"
    local emTarget2First = "#7bc7d0"
    local emTarget2Second = "#368c96"
    u.Hi("HopNextKey", { guibg = "NONE", guifg = emTarget1, gui = "bold" })
    u.Hi("HopNextKey1", { guibg = "NONE", guifg = emTarget2First, gui = "bold" })
    u.Hi("HopNextKey2", { guibg = "NONE", guifg = emTarget2Second })

    -- Suppress overly-aggressive error u.Highlighting under Treesitter
    u.HiClear "TSError"

    u.Hi("markdownLinkText", { gui = "underline", guifg = nord.nord9 })
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

-- Example config in lua
vim.g.nord_bold = 1
vim.g.nord_underline = 1
vim.g.nord_italic = 1
vim.g.nord_italic_comments = 1
vim.g.nord_uniform_status_lines = 0
vim.g.nord_cursor_line_number_background = 0
vim.g.nord_uniform_diff_background = 0

-- Finally, force application of my highlight customizations by triggering autocmd
vim.cmd [[ colo nord ]]

-- Exports
return M
