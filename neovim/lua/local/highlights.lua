
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
end

-- Customisations of stock highlights
vim.api.nvim_set_hl(0, "ColorColumn", { link = "Pmenu" })
vim.api.nvim_set_hl(0, "FoldColumn", { link = "NonText" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { link = "NonText" })
vim.api.nvim_set_hl(0, "QuickFixLine", { link = "Pmenu" })
vim.api.nvim_set_hl(0, "NormalFloat", { link = "Pmenu" })


---
--- See <https://gist.github.com/swarn/fb37d9eefe1bc616c2a7e476c0bc0316>
--- for a comprehensive guide to Semantic highlighting in Neovim.
---

-- (Vim highlights)
vim.api.nvim_set_hl(0, "Constant", { fg="NvimLightCyan" })

-- (Treesitter highlights)
vim.api.nvim_set_hl(0, "@property", { link="Normal" })
vim.api.nvim_set_hl(0, "@constant", { fg="NvimLightCyan", italic=true })
vim.api.nvim_set_hl(0, "@variable.parameter", { fg="NvimLightMagenta" })

-- (Semantic highlights)
vim.api.nvim_set_hl(0, "@lsp.mod.global", { fg="NvimLightRed" })
vim.api.nvim_set_hl(0, "@lsp.type.parameter", { fg="NvimLightMagenta" })
vim.api.nvim_set_hl(0, "@lsp.type.property", { link="Normal" })
vim.api.nvim_set_hl(0, "@lsp.type.variable", { fg="NvimLightBlue" })

vim.api.nvim_set_hl(0, "mkdLinkDef", { fg="NvimLightBlue" })
vim.api.nvim_set_hl(0, "mkdLink", { link = "mkdLinkDef" })
vim.api.nvim_set_hl(0, "mkdInlineURL", { link = "mkdLinkDef" })
vim.api.nvim_set_hl(0, "@markup.link.label.markdown_inline", { link = "mkdLinkDef" })
vim.api.nvim_set_hl(0, "@markup.link.url.markdown_inline", { link = "mkdLinkDef" })
vim.api.nvim_set_hl(0, "@markup.quote.markdown", { link = "mkdBlockQuote" })
vim.api.nvim_set_hl(0, "@markup.raw.markdown_inline", { link = "mkdCode" })

vim.api.nvim_set_hl(0, "LspCodeLens", { link = "NonText" })
vim.api.nvim_set_hl(0, "LspCodeLensSeparator", { link = "Comment" })
vim.api.nvim_set_hl(0, "LspReferenceRead", { fg="Black", bg= "NvimLightGreen" })
vim.api.nvim_set_hl(0, "LspReferenceWrite", { fg="Black", bg= "NvimLightRed" })

vim.api.nvim_set_hl(0, "DiagnosticLineNrError", { link = "DiagnosticError" })
vim.api.nvim_set_hl(0, "DiagnosticLineNrWarn", { link = "DiagnosticWarn" })
vim.api.nvim_set_hl(0, "DiagnosticLineNrInfo", { link = "DiagnosticInfo" })
vim.api.nvim_set_hl(0, "DiagnosticLineNrHint", { link = "DiagnosticHint" })
vim.cmd [[ highlight LspInlayHint guifg=NvimDarkGrey4 guibg=NONE gui=italic ]]

-- Active statusbar override for default theme
vim.cmd [[ highlight StatusLine cterm=reverse guifg=#a0a8b7 guibg=#30363f ]]

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

vim.cmd [[
    highlight MiniStatusLineModeInsert gui=bold guifg=#1f2329 guibg=#4fa6ed
    highlight MiniStatusLineModeCommand gui=bold guifg=#1f2329 guibg=#e2b86b
    highlight MiniStatusLineModeOther gui=bold guifg=#1f2329 guibg=#48b0bd
    highlight MiniStatusLineModeReplace gui=bold guifg=#1f2329 guibg=#e55561
    highlight MiniStatusLineModeNormal gui=bold guifg=#1f2329 guibg=#8ebd6b
    highlight MiniStatusLineModeVisual gui=bold guifg=#1f2329 guibg=#bf68d9
]]

vim.api.nvim_set_hl(0, "StatusLineModeNormal", { bold = true })
vim.api.nvim_set_hl(0, "StatusLineModeCommand", { link = "MiniStatusLineModeInsert" })
vim.api.nvim_set_hl(0, "StatusLineModeEx", { link = "MiniStatusLineModeCommand" })
vim.api.nvim_set_hl(0, "StatusLineModeInsert", { link = "MiniStatusLineModeOther" })
vim.api.nvim_set_hl(0, "StatusLineModeReplace", { link = "MiniStatusLineModeReplace" })
vim.api.nvim_set_hl(0, "StatusLineModeTerminal", { link = "MiniStatusLineModeNormal" })
vim.api.nvim_set_hl(0, "StatusLineModeVisual", { link = "MiniStatusLineModeCommand" })
vim.api.nvim_set_hl(0, "StatusLineModeSelect", { link = "MiniStatusLineModeVisual" })

