
  -- // Default Neovim palettes.
  -- // Dark/light palette is used for background in dark/light color scheme and
  -- // for foreground in light/dark color scheme.
  --
  -- NvimDarkBlue, NvimDarkCyan, NvimDarkGray1, NvimDarkGray2, NvimDarkGray3,
  -- NvimDarkGray4, NvimDarkGreen, NvimDarkGrey1, NvimDarkGrey2, NvimDarkGrey3,
  -- NvimDarkGrey4, NvimDarkMagenta, NvimDarkRed, NvimDarkYellow,
  --
  -- NvimLightBlue, NvimLightCyan, NvimLightGray1, NvimLightGray2,
  -- NvimLightGray3, NvimLightGray4, NvimLightGreen, NvimLightGrey1,
  -- NvimLightGrey2, NvimLightGrey3, NvimLightGrey4, NvimLightMagenta,
  -- NvimLightRed, NvimLightYellow,


-- If using the default Neovim color scheme, force-reset all highlight groups
if vim.g.colors_name == nil or vim.g.colors_name == "default" then

    -- HACK: default colour scheme changes assigned colours depend on 'background' option.
    --
    -- Tweak highlight groups' properties while preserving stock colours by monkey-patching
    -- the default colourscheme when the background colour changes

    if string.find(vim.env.TERM, "xterm-kitty", 1, true) ~= nil then

        -- Reset highlight groups to default
        vim.cmd [[ color default ]]

        -- Tweak stock colors for highlight groups.
        -- (This doesn't work in Lua)
        vim.cmd [[
            highlight DiagnosticUnderlineError gui=undercurl
            highlight DiagnosticUnderlineWarn gui=undercurl
            highlight DiagnosticUnderlineInfo gui=undercurl
            highlight DiagnosticUnderlineHint gui=undercurl
        ]]
    end

    vim.api.nvim_set_hl(0, "Normal", { bg = "none"})
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none"})
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none"})
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none"})
end

-- Customisations of stock highlights
vim.api.nvim_set_hl(0, "ColorColumn", { link = "Pmenu" })
vim.api.nvim_set_hl(0, "FoldColumn", { link = "NonText" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { link = "NonText" })

vim.api.nvim_set_hl(0, "mkdLinkDef", { fg="NvimLightBlue", underline=true })
vim.api.nvim_set_hl(0, "mkdLink", { link = "mkdLinkDef" })
vim.api.nvim_set_hl(0, "mkdInlineURL", { link = "mkdLinkDef" })
vim.api.nvim_set_hl(0, "@markup.link.label.markdown_inline", { link = "mkdLinkDef" })
vim.api.nvim_set_hl(0, "@markup.link.url.markdown_inline", { link = "mkdLinkDef" })
vim.api.nvim_set_hl(0, "@markup.quote.markdown", { link = "mkdBlockQuote" })
vim.api.nvim_set_hl(0, "@markup.raw.markdown_inline", { link = "mkdCode" })
vim.api.nvim_set_hl(0, "Identifier", { link="NonText" })

vim.api.nvim_set_hl(0, "LspCodeLens", { fg="NvimLightMagenta" })
vim.api.nvim_set_hl(0, "LspCodeLensSeparator", { link = "Comment" })
vim.api.nvim_set_hl(0, "LspReferenceRead", { fg="Black", bg= "NvimLightGreen" })

vim.api.nvim_set_hl(0, "DiagnosticLineNrError", { link = "DiagnosticError" })
vim.api.nvim_set_hl(0, "DiagnosticLineNrWarn", { link = "DiagnosticWarn" })
vim.api.nvim_set_hl(0, "DiagnosticLineNrInfo", { link = "DiagnosticInfo" })
vim.api.nvim_set_hl(0, "DiagnosticLineNrHint", { link = "DiagnosticHint" })
vim.cmd [[ highlight LspInlayHint guifg=NvimDarkGrey4 guibg=NONE gui=italic ]]

-- Inactive statusbars: make a thin rule; align vertsplit to match.
vim.cmd [[ highlight StatusLineNC guifg=NONE guisp=NvimDarkGrey4 guibg=NONE gui=underline ]]
vim.api.nvim_set_hl(0, "VertSplit", { link = "NonText" })
vim.api.nvim_set_hl(0, "WinSeparator", { link = "NonText" })

-- Plugin: Luasnip
vim.api.nvim_set_hl(0, "LuasnipChoiceNodeVirtualText", { link = "@diff.minus" })
vim.api.nvim_set_hl(0, "LuasnipInsertNodeVirtualText", { link = "@diff.delta" })

-- Plugin: NVimtree
vim.api.nvim_set_hl(0, "NvimTreeFolderName", { link = "NvimTreeNormal" })
vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderIcon", { link = "NvimTreeFolderIcon" })
vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { link = "NvimTreeNormal" })
vim.api.nvim_set_hl(0, "NvimTreeEmptyFolderIcon", { link = "NvimTreeFolderIcon" })
vim.api.nvim_set_hl(0, "NvimTreeEmptyFolderName", { link = "NvimTreeFolderIcon" })
vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { link = "NonText" })

-- Plugin: Notify
vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "NvimDarkGrey1" })

-- My custom winbar
vim.cmd [[
    highlight Winbar gui=italic guibg=NONE guifg=#535965
    highlight WinbarNC gui=italic guibg=NONE guifg=#535965
]]

vim.api.nvim_set_hl(0, "ErrorWinbarDiagIndic", { link = "DiagnosticError" })
vim.api.nvim_set_hl(0, "WarnWinbarDiagIndic", { link = "DiagnosticWarn" })
vim.api.nvim_set_hl(0, "InfoWinbarDiagIndic", { link = "DiagnosticInfo" })
vim.api.nvim_set_hl(0, "HintWinbarDiagIndic", { link = "DiagnosticHint" })
vim.api.nvim_set_hl(0, "OkWinbarDiagIndic", { link = "DiagnosticOk" })

-- My custom statusbar  (NOTE: linked highlights chosen to look nicer, not match logicically)
vim.api.nvim_set_hl(0, "StatusLineModeNormal", { bold = true })
vim.api.nvim_set_hl(0, "StatusLineModeCommand", { bg="NvimLightBlue", bold = true })
vim.api.nvim_set_hl(0, "StatusLineModeEx", { bg="NvimLightBlue", bold = true })
vim.api.nvim_set_hl(0, "StatusLineModeInsert", { bg="NvimLightCyan", bold = true })
vim.api.nvim_set_hl(0, "StatusLineModeReplace", { bg="NvimLightRed", bold = true })
vim.api.nvim_set_hl(0, "StatusLineModeTerminal", { bg="NvimLightGreen", bold = true })
vim.api.nvim_set_hl(0, "StatusLineModeVisual", { bg="NvimLightYellow", bold = true })
vim.api.nvim_set_hl(0, "StatusLineModeSelect", { bg="NvimLightMagenta", bold = true })

