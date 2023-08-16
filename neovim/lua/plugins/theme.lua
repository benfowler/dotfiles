return {
    {
        "gbprod/nord.nvim",
        name = "nord",
        lazy = false,
        priority = 1000,

        config = function()
            vim.cmd.colorscheme "nord"

            -- Adapted from shaunsingh/nord.nvim
            local nord = {
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

            -- (poor readability of some u.Highlight groups)
            -- (Stock fg was: fg = nord3_gui, ctermfg=nord3_term)
            vim.api.nvim_set_hl(0, "SpecialKey", { fg = nord.nord3_bright, ctermfg = 8 })

            -- (Stock fg was: fg = nord2_gui, gui=bold, ctermfg=nord3_term)
            vim.api.nvim_set_hl(0, "NonText", {}) -- clear
            vim.api.nvim_set_hl(0, "NonText", { fg = nord.nord10, ctermfg = 5 })

            -- (Pmenu: stock BG was: bg=nord2_gui, ctermbg=nord1_term)
            vim.api.nvim_set_hl(0, "Pmenu", { bg = nord.nord2, ctermbg = 8 })

            -- (Pmenu: stock BG was: bg=nord3_gui, ctermbg=nord3_term)
            vim.api.nvim_set_hl(0, "PmenuThumb", { bg = nord.nord3_bright, ctermbg = 8 })

            vim.api.nvim_set_hl(0, "PmenuSel", {}) -- clear
            vim.api.nvim_set_hl(0, "PmenuSel", { bg = nord.nord8, fg = nord.nord1 })

            -- (nvim-cmp's custom-drawn autocompletion menu)
            vim.api.nvim_set_hl(0, "CmpItemAbbr", { fg = nord.nord5 })
            vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { fg = nord.nord4, strikethrough = true })
            vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = nord.nord9 })
            vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = nord.nord12 })
            vim.api.nvim_set_hl(0, "CmpItemKind", { fg = nord.nord15 })
            vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = nord.nord3_bright })

            -- (VS Code-like highlighting of kinds)
            -- light blue
            vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = "#9CDCFE" })
            vim.api.nvim_set_hl(0, "CmpItemKindInterface", { fg = "#9CDCFE" })
            vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = "#9CDCFE" })
            vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = "#9CDCFE" })
            -- pink
            vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = "#C586C0" })
            vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = "#C586C0" })
            -- front
            vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = "#D4D4D4" })
            vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = "#D4D4D4" })
            vim.api.nvim_set_hl(0, "CmpItemKindUnit", { fg = "#D4D4D4" })

            vim.api.nvim_set_hl(0, "CmpGhostText", { fg = nord.nord12 })

            -- QuickFix list's line numbers are unreadable
            vim.api.nvim_set_hl(0, "qfFileName", { fg = nord.nord10 })
            vim.api.nvim_set_hl(0, "qfLineNr", { fg = nord.nord8 })
            vim.api.nvim_set_hl(0, "QuickFixLine", { bg = nord.nord7, fg = "Black" })

            vim.api.nvim_set_hl(0, "MatchParen", { fg = nord.nord12, bold = true, bg = nord.nord2 })

            -- Active statusbar: override 'StatusLine' u.Highlight with Nord-ish colours
            vim.api.nvim_set_hl(0, "StatusLine", { fg = statusline_active_fg, bg = statusline_active_bg })

            vim.api.nvim_set_hl(0, "StatusLineError", { fg = error_fg, bg = statusline_active_bg })
            vim.api.nvim_set_hl(0, "StatusLineWarn", { fg = warn_fg, bg = statusline_active_bg })
            vim.api.nvim_set_hl(0, "StatusLineInfo", { fg = info_fg, bg = statusline_active_bg })
            vim.api.nvim_set_hl(0, "StatusLineHint", { fg = hint_fg, bg = statusline_active_bg })
            vim.api.nvim_set_hl(0, "StatusLineOk", { fg = ok_fg, bg = statusline_active_bg })
            vim.api.nvim_set_hl(0, "StatusLineAdd", { fg = diff_add, bg = statusline_active_bg })
            vim.api.nvim_set_hl(0, "StatusLineChange", { fg = diff_change, bg = statusline_active_bg })
            vim.api.nvim_set_hl(0, "StatusLineDelete", { fg = diff_delete, bold = true, bg = statusline_active_bg })

            vim.api.nvim_set_hl(
                0,
                "StatusLineModeNormal",
                { fg = statusline_active_fg, bold = true, bg = statusline_active_bg }
            )
            vim.api.nvim_set_hl(0, "StatusLineModeInsert", { fg = nord.nord8, bold = true, bg = statusline_active_bg })
            vim.api.nvim_set_hl(0, "StatusLineModeVisual", { fg = nord.nord13, bold = true, bg = statusline_active_bg })
            vim.api.nvim_set_hl(
                0,
                "StatusLineModeReplace",
                { fg = nord.nord12, bold = true, bg = statusline_active_bg }
            )
            vim.api.nvim_set_hl(0, "StatusLineModeCommand", { fg = nord.nord7, bold = true, bg = statusline_active_bg })
            vim.api.nvim_set_hl(
                0,
                "StatusLineModeTerminal",
                { fg = nord.nord14, bold = true, bg = statusline_active_bg }
            )
            vim.api.nvim_set_hl(0, "StatusLineModeEx", { fg = nord.nord12, bold = true, bg = statusline_active_bg })

            -- Inactive statusbars: make a thin rule; align VertSplit to match.
            vim.api.nvim_set_hl(0, "StatusLineNC", {})
            vim.api.nvim_set_hl(0, "StatusLineNC", { underline = true, fg = nord.nord3 })
            vim.api.nvim_set_hl(0, "VertSplit", { bg = "NONE", ctermbg = "NONE", fg = nord.nord3 })
            vim.api.nvim_set_hl(0, "WinSeparator", { bg = "NONE", ctermbg = "NONE", fg = nord.nord3 })

            -- Line numbers: tweaks to show current line
            vim.api.nvim_set_hl(0, "CursorLineNr", {})
            vim.api.nvim_set_hl(0, "CursorLineNr", { link = "Bold" })

            -- Message area
            vim.api.nvim_set_hl(0, "MsgArea", { fg = statusline_active_fg })
            vim.api.nvim_set_hl(0, "ErrorMsg", { fg = error_fg, bg = "NONE" })
            vim.api.nvim_set_hl(0, "WarningMsg", { fg = warn_fg, bg = "NONE" })

            -- Winbar
            vim.api.nvim_set_hl(0, "WinBar", { fg = statusline_active_fg, italic = true })

            -- Incremental search highlighting
            vim.api.nvim_set_hl(0, "Search", { fg = nord.nord0, bg = nord.nord13, bold = true })

            vim.api.nvim_set_hl(0, "ErrorWinbarDiagIndic", { fg = error_fg })
            vim.api.nvim_set_hl(0, "WarnWinbarDiagIndic", { fg = warn_fg })
            vim.api.nvim_set_hl(0, "InfoWinbarDiagIndic", { fg = info_fg })
            vim.api.nvim_set_hl(0, "HintWinbarDiagIndic", { fg = hint_fg })
            vim.api.nvim_set_hl(0, "OkWinbarDiagIndic", { fg = ok_fg })

            -- LSP diagnostics: line number backgrounds and foregrounds
            --('black' is #667084; bg colours are a blend)
            vim.api.nvim_set_hl(0, "DiagnosticError", { fg = error_fg })
            vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = warn_fg })
            vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = info_fg })
            vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = hint_fg })

            vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = error_fg, italic = true })
            vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = warn_fg, italic = true })
            vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = info_fg, italic = true })
            vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = hint_fg, italic = true })

            -- Are we running 'kitty' and support undercurl and coloured underlines?
            if string.find(vim.env.TERM, "xterm-kitty", 1, true) ~= nil then
                vim.api.nvim_set_hl(
                    0,
                    "DiagnosticUnderlineError",
                    { fg = "NONE", bg = "NONE", sp = error_fg, undercurl = true }
                )
                vim.api.nvim_set_hl(
                    0,
                    "DiagnosticUnderlineWarn",
                    { fg = "NONE", bg = "NONE", sp = warn_fg, undercurl = true }
                )
                vim.api.nvim_set_hl(
                    0,
                    "DiagnosticUnderlineInfo",
                    { fg = "NONE", bg = "NONE", sp = info_fg, undercurl = true }
                )
                vim.api.nvim_set_hl(
                    0,
                    "DiagnosticUnderlineHint",
                    { fg = "NONE", bg = "NONE", sp = hint_fg, undercurl = true }
                )

                -- Tweak undercurl colour with Nord colours
                vim.api.nvim_set_hl(0, "SpellBad", { sp = spell_bad_fg, undercurl = true })
                vim.api.nvim_set_hl(0, "SpellCap", { sp = spell_cap_fg, undercurl = true })
                vim.api.nvim_set_hl(0, "SpellLocal", { sp = spell_local_fg, undercurl = true })
                vim.api.nvim_set_hl(0, "SpellRare", { sp = spell_rare_fg, undercurl = true })
            else
                vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { fg = error_fg, bg = "NONE", underline = true })
                vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { fg = warn_fg, bg = "NONE", underline = true })
                vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { fg = info_fg, bg = "NONE", underline = true })
                vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { fg = hint_fg, bg = "NONE", underline = true })
            end

            vim.api.nvim_set_hl(0, "DiagnosticLineNrError", { link = "DiagnosticError" })
            vim.api.nvim_set_hl(0, "DiagnosticLineNrWarn", { link = "DiagnosticWarn" })
            vim.api.nvim_set_hl(0, "DiagnosticLineNrInfo", { link = "DiagnosticInfo" })
            vim.api.nvim_set_hl(0, "DiagnosticLineNrHint", { link = "DiagnosticHint" })

            vim.api.nvim_set_hl(0, "DiagnosticFloatingError", { link = "DiagnosticError" })
            vim.api.nvim_set_hl(0, "DiagnosticFloatingWarn", { link = "DiagnosticWarn" })
            vim.api.nvim_set_hl(0, "DiagnosticFloatingInfo", { link = "DiagnosticInfo" })
            vim.api.nvim_set_hl(0, "DiagnosticFloatingHint", { link = "DiagnosticHint" })

            vim.api.nvim_set_hl(0, "DiagnosticSignError", { link = "DiagnosticError" })
            vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { link = "DiagnosticWarn" })
            vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { link = "DiagnosticInfo" })
            vim.api.nvim_set_hl(0, "DiagnosticSignHint", { link = "DiagnosticHint" })

            vim.api.nvim_set_hl(0, "LspReferenceRead", { fg = nord.nord14, bg = nord.nord2, bold = true })
            vim.api.nvim_set_hl(0, "LspReferenceWrite", { fg = nord.nord15, bg = nord.nord2, bold = true })
            vim.api.nvim_set_hl(0, "LspReferenceText", { bg = nord.nord1 })

            -- LSP CodeLenses (rendered as virtual text)
            vim.api.nvim_set_hl(0, "LspCodeLens", { fg = misc2_fg, italic = true })
            vim.api.nvim_set_hl(0, "LspCodeLensSeparator", { link = "Comment" })

            -- Luasnip
            vim.api.nvim_set_hl(0, "LuasnipChoiceNodeVirtualText", { fg = nord.nord12 })
            vim.api.nvim_set_hl(0, "LuasnipInsertNodeVirtualText", { fg = nord.nord8 })

            -- Fold indicators
            vim.api.nvim_set_hl(0, "FoldColumn", { fg = nord.nord3_bright })
            vim.api.nvim_set_hl(0, "CursorLineFold", { fg = nord.nord4_dim })

            -- Git gutter signs.  Different palette for gutter decorations
            --  vs regular diff colours, to increase contrast.
            local diff_add_gutter = nord.nord12
            local diff_change_gutter = nord.nord13
            vim.api.nvim_set_hl(0, "GitSignsAdd", { bold = true, fg = diff_add_gutter })
            vim.api.nvim_set_hl(0, "GitSignsChange", { fg = diff_change_gutter })
            vim.api.nvim_set_hl(0, "GitSignsDelete", { bold = true, fg = diff_delete })
            vim.api.nvim_set_hl(0, "GitSignsChangeDelete", { bold = true, fg = nord.nord11 })

            -- Telescope (lifted from FZF Nord theme)
            vim.api.nvim_set_hl(0, "TelescopeSelection", { bold = true })
            vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = nord.nord13, bold = true })
            vim.api.nvim_set_hl(0, "TelescopeMultiSelection", { fg = nord.nord14 })
            vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = nord.nord9 })
            vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { fg = "#bf6069" })
            vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = nord.nord3_bright })

            -- Floating info and rename/select popups (latter via stevearc/nvim-dressing)

            -- NOTE: for future use with 'smart' diag popups
            vim.api.nvim_set_hl(0, "ErrorFloatBorder", { fg = error_fg })
            vim.api.nvim_set_hl(0, "WarnFloatBorder", { fg = warn_fg })
            vim.api.nvim_set_hl(0, "InfoFloatBorder", { fg = info_fg })
            vim.api.nvim_set_hl(0, "HintFloatBorder", { fg = hint_fg })
            vim.api.nvim_set_hl(0, "OkFloatBorder", { fg = ok_fg })
            vim.api.nvim_set_hl(0, "DimFloatBorder", { fg = nord.nord3_bright })

            vim.api.nvim_set_hl(0, "NormalFloat", { bg = nord.nord1 })
            vim.api.nvim_set_hl(0, "FloatTitle", { fg = nord.nord4, bold = true })
            vim.api.nvim_set_hl(0, "FloatBorder", { link = "DimFloatBorder" })

            -- ... popups that are informational are highlighted like info
            -- TODO: find way to attach these to LSP config
            vim.api.nvim_set_hl(0, "LspHoverFloatBorder", { link = "InfoFloatBorder" })
            vim.api.nvim_set_hl(0, "LspSignatureHelpFloatBorder", { link = "InfoFloatBorder" })

            -- ... popups that change stuff are highlighted like warnings
            vim.api.nvim_set_hl(0, "DressingFloatBorder", { link = "WarnFloatBorder" })

            -- ... nvim-cmp doc floats must be explicitly set
            vim.api.nvim_set_hl(0, "CmpDocFloatBorder", { link = "DimFloatBorder" })

            -- Indent guides
            vim.api.nvim_set_hl(0, "IndentBlanklineChar", { fg = nord.nord1 })
            vim.api.nvim_set_hl(0, "IndentBlanklineContextChar", { fg = nord.nord3_bright })

            -- nvim-notify
            vim.api.nvim_set_hl(0, "NotifyDEBUGBorder", { fg = nord.nord3 })
            vim.api.nvim_set_hl(0, "NotifyDEBUGIcon", { fg = nord.nord3 })
            vim.api.nvim_set_hl(0, "NotifyDEBUGTitle", { fg = nord.nord3 })
            vim.api.nvim_set_hl(0, "NotifyERRORBorder", { fg = nord.nord11 })
            vim.api.nvim_set_hl(0, "NotifyERRORIcon", { fg = nord.nord11 })
            vim.api.nvim_set_hl(0, "NotifyERRORTitle", { fg = nord.nord11 })
            vim.api.nvim_set_hl(0, "NotifyINFOBorder", { fg = nord.nord14 })
            vim.api.nvim_set_hl(0, "NotifyINFOIcon", { fg = nord.nord14 })
            vim.api.nvim_set_hl(0, "NotifyINFOTitle", { fg = nord.nord14 })
            vim.api.nvim_set_hl(0, "NotifyTRACEBorder", { fg = nord.nord15 })
            vim.api.nvim_set_hl(0, "NotifyTRACEIcon", { fg = nord.nord15 })
            vim.api.nvim_set_hl(0, "NotifyTRACETitle", { fg = nord.nord15 })
            vim.api.nvim_set_hl(0, "NotifyWARNBorder", { fg = nord.nord13 })
            vim.api.nvim_set_hl(0, "NotifyWARNIcon", { fg = nord.nord13 })
            vim.api.nvim_set_hl(0, "NotifyWARNTitle", { fg = nord.nord13 })


      -- fzf.  These feed FZF_COLORS.  They are _meant_ to be populated from
      -- existing highlight groups, but I am using 'Nord' colours which look
      -- better than the stock colors.
      --
      -- NOTE: Use the FZF color picker:  https://minsw.github.io/fzf-color-picker/

      -- stylua: ignore start
      vim.api.nvim_set_hl(0, "FzfFg",      { fg = "#e5e9f0", bg=nord.nord3 })
      vim.api.nvim_set_hl(0, "FzfBg",      { bg = "#2e3440" })
      vim.api.nvim_set_hl(0, "FzfHl",      { fg = "#81a1c1", bg=nord.nord3 })

      vim.api.nvim_set_hl(0, "FzfFg_",     { fg = "#e5e9f0", bold = true, bg=nord.nord1 })
      vim.api.nvim_set_hl(0, "FzfBg_",     {                 bold = true, bg=nord.nord1 })
      vim.api.nvim_set_hl(0, "FzfHl_",     { fg = "#81a1c1", bold = true, bg=nord.nord1 })

      vim.api.nvim_set_hl(0, "FzfInfo",    { fg = "#eacb8a" })
      vim.api.nvim_set_hl(0, "FzfBorder",  { fg = "#616E88" })
      vim.api.nvim_set_hl(0, "FzfPrompt",  { fg = "#bf6069" })
      vim.api.nvim_set_hl(0, "FzfPointer", { fg = "#b48dac" })
      vim.api.nvim_set_hl(0, "FzfMarker",  { fg = "#a3be8b" })
      vim.api.nvim_set_hl(0, "FzfSpinner", { fg = "#b48dac" })
      vim.api.nvim_set_hl(0, "FzfHeader",  { fg = "#a3be8b" })
            -- stylua: ignore end

            -- nvim-tree
            vim.api.nvim_set_hl(0, "NvimTreeNormal", { fg = nord.nord4 })
            vim.api.nvim_set_hl(0, "NvimTreeOpenedFile", { bold = true })

            vim.api.nvim_set_hl(0, "NvimTreeIndentMarker", { fg = nord.nord2 })

            vim.api.nvim_set_hl(0, "NvimTreeFolderIcon", { fg = nord.nord3_bright })
            vim.api.nvim_set_hl(0, "NvimTreeFolderName", { link = "NvimTreeNormal" })

            vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderIcon", { link = "NvimTreeFolderIcon" })
            vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { link = "NvimTreeNormal" })

            vim.api.nvim_set_hl(0, "NvimTreeEmptyFolderIcon", { link = "NvimTreeFolderIcon" })
            vim.api.nvim_set_hl(0, "NvimTreeEmptyFolderName", { link = "NvimTreeFolderIcon" })

            vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { link = "WinSeparator" })

            -- Fidget: inlay LSP plugin status messages
            vim.api.nvim_set_hl(0, "FidgetTitle", { bold = true, fg = nord.nord15, bg = nord.nord0 })
            vim.api.nvim_set_hl(0, "FidgetTask", { fg = nord.nord3_bright, bg = nord.nord0 })

            -- Latex tweaks
            vim.api.nvim_set_hl(0, "texCmdEnv", { fg = nord.nord15, bold = true })
            vim.api.nvim_set_hl(0, "texCmdEnvM", { fg = nord.nord7, bold = true })
            vim.api.nvim_set_hl(0, "texDelim", { fg = nord.nord3 })
            vim.api.nvim_set_hl(0, "texMathDelim", { fg = nord.nord10, bold = true })
            vim.api.nvim_set_hl(0, "texMathTextConcArg", { fg = nord.nord3_bright, italic = true })
            vim.api.nvim_set_hl(0, "texSICmd", { fg = nord.nord14 })

            -- vim-easymotion
            local emTarget1 = "#d0505A"
            local emTarget2First = "#7bc7d0"
            local emTarget2Second = "#368c96"
            vim.api.nvim_set_hl(0, "HopNextKey", { bg = "NONE", fg = emTarget1, bold = true })
            vim.api.nvim_set_hl(0, "HopNextKey1", { bg = "NONE", fg = emTarget2First, bold = true })
            vim.api.nvim_set_hl(0, "HopNextKey2", { bg = "NONE", fg = emTarget2Second })

            -- Suppress overly-aggressive error u.Highlighting under Treesitter
            vim.api.nvim_set_hl(0, "TSError", {})

            vim.api.nvim_set_hl(0, "markdownLinkText", { underline = true, fg = nord.nord9 })
            vim.api.nvim_set_hl(0, "mkdLink", { underline = true, fg = nord.nord9 })
            vim.api.nvim_set_hl(0, "mkdCode", { fg = nord.nord7 })

            --
            -- Re-initialize web-devicons with Nord colours
            --

            local icon_colors = {
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

            local web_devicons_loaded, web_devicons = pcall(require, "nvim-web-devicons")

            --if web_devicons_loaded then
            if false then
                web_devicons.setup {
                    override = {
                        html = { icon = "", color = icon_colors.orange, name = "html" },
                        css = { icon = "󰌜", color = icon_colors.blue, name = "css" },
                        scss = { icon = "", color = icon_colors.pink, name = "scss" },
                        sass = { icon = "", color = icon_colors.pink, name = "sass" },
                        js = { icon = "󰌞", color = icon_colors.yellow, name = "js" },
                        ts = { icon = "󰛦", color = icon_colors.blue, name = "ts" },
                        kt = { icon = "󱈙", color = icon_colors.orange, name = "kt" },
                        png = { icon = "󰋩", color = icon_colors.magenta, name = "png" },
                        jpg = { icon = "󰋩", color = icon_colors.cyan, name = "jpg" },
                        jpeg = { icon = "󰋩", color = icon_colors.cyan, name = "jpeg" },
                        java = { icon = "", color = icon_colors.lightblue, name = "java" },
                        mp3 = { icon = "󰎆", color = icon_colors.green, name = "mp3" },
                        mp4 = { icon = "", color = icon_colors.green, name = "mp4" },
                        out = { icon = "󰅬", color = icon_colors.blue, name = "out" },
                        rb = { icon = "", color = icon_colors.red, name = "rb" },
                        scala = { icon = "", color = icon_colors.red, name = "scala" },
                        sc = { icon = "", color = icon_colors.red, name = "scala" },
                        sh = { icon = "", color = icon_colors.green, name = "sh" },
                        bash = { icon = "", color = icon_colors.green, name = "bash" },
                        sbt = { icon = "", color = icon_colors.red, name = "sbt" },
                        vue = { icon = "󰡄", color = icon_colors.green, name = "vue" },
                        py = { icon = "", color = icon_colors.orange, name = "py" },
                        toml = { icon = "", color = icon_colors.blue, name = "toml" },
                        lock = { icon = "󰌾", color = icon_colors.red, name = "lock" },
                        zip = { icon = "", color = icon_colors.cyan, name = "zip" },
                        xz = { icon = "", color = icon_colors.cyan, name = "xz" },
                        deb = { icon = "", color = icon_colors.red, name = "deb" },
                        rpm = { icon = "", color = icon_colors.red, name = "rpm" },
                        lua = { icon = "", color = icon_colors.blue, name = "lua" },
                        txt = { icon = "󰈙", color = icon_colors.blue, name = "txt" },
                        md = { icon = "", color = icon_colors.cyan, name = "markdown" },
                        graphql = { icon = "", color = icon_colors.pink, name = "graphql" },
                        env = { icon = "", color = icon_colors.yellow, name = "dotenvexample" },
                        [".env.production"] = { icon = "", color = icon_colors.yellow, name = "envprod" },
                        [".env.development"] = { icon = "", color = icon_colors.yellow, name = "envdev" },
                        [".env.testing"] = { icon = "", color = icon_colors.yellow, name = "envtest" },
                        [".env.example"] = { icon = "", color = icon_colors.yellow, name = "dotenvexample" },
                        [".env"] = { icon = "", color = icon_colors.yellow, name = "dotenv" },
                        ["docker-compose.yml"] = { icon = "", color = icon_colors.cyan, name = "dockercompose" },
                        [".dockerignore"] = { icon = "", color = icon_colors.blue, name = "dockerignore" },
                        [".prettierignore"] = { icon = "󰏣", color = icon_colors.orange, name = "prettierignore" },
                        [".prettierrc"] = { icon = "󰏣", color = icon_colors.cyan, name = "prettier" },
                        [".prettierrc.json"] = { icon = "󰏣", color = icon_colors.cyan, name = "prettierjson" },
                        [".prettierrc.js"] = { icon = "󰏣", color = icon_colors.cyan, name = "prettierrcjs" },
                        ["prettier.config.js"] = { icon = "󰏣", color = icon_colors.cyan, name = "prettierjsconfig" },
                        [".prettier.yaml"] = { icon = "󰏣", color = icon_colors.cyan, name = "prettieryaml" },
                        ["test.js"] = { icon = "", color = icon_colors.yellow, name = "javascripttest" },
                        ["test.jsx"] = { icon = "", color = icon_colors.yellow, name = "reactrest" },
                        ["test.ts"] = { icon = "", color = icon_colors.blue, name = "typescripttest" },
                        ["test.tsx"] = { icon = "", color = icon_colors.blue, name = "reacttypescripttest" },
                        ["spec.js"] = { icon = "", color = icon_colors.yellow, name = "javascriptspectest" },
                        ["spec.jsx"] = { icon = "", color = icon_colors.yellow, name = "reactspectest" },
                        ["spec.ts"] = { icon = "", color = icon_colors.blue, name = "typescriptspectest" },
                        ["spec.tsx"] = { icon = "", color = icon_colors.blue, name = "reacttypescriptspectest" },
                        ["vim"] = { icon = "", color = icon_colors.green, name = "vim" },
                        ["yarn-error.log"] = { icon = "󰄛", color = icon_colors.red, name = "yarnerrorlog" },
                        ["yarn.lock"] = { icon = "󰄛", color = icon_colors.blue, name = "yarnlock" },
                        ["package.json"] = { icon = "", color = icon_colors.red, name = "npm_packagejson" },
                        [".gitignore"] = { icon = "", color = icon_colors.orange, name = "gitignore" },
                        [".gitattributes"] = { icon = "", color = icon_colors.orange, name = "gitattributes" },
                        ["Dockerfile"] = { icon = "", color = icon_colors.blue, name = "dockerfilex" },
                        [".nvmrc"] = { icon = "", color = icon_colors.green, name = "nvmrc" },
                        [".eslintrc.js"] = { icon = "󰛸", color = icon_colors.magenta, name = "eslintrcjs" },
                        [".travis.yml"] = { icon = "", color = icon_colors.red, name = "travis" },
                        ["babel.config.js"] = { icon = "󰂡", color = icon_colors.yellow, name = "babelconfig" },
                        [".commitlintrc.json"] = { icon = "󰜜", color = icon_colors.green, name = "commitlinrcjson" },
                        zsh = { icon = "", color = icon_colors.green, name = "zsh" },
                    },
                    default = true,
                }
            end
        end,
    },
}
