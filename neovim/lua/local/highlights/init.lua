
-- Customisations of stock highlights
vim.api.nvim_set_hl(0, "mkdLink", { link = "mkdLinkDef" })
vim.api.nvim_set_hl(0, "mkdInlineURL", { link = "mkdLinkDef" })
vim.api.nvim_set_hl(0, "LspCodeLens", { link = "DiagnosticOk" })
vim.api.nvim_set_hl(0, "LspCodeLensSeparator", { link = "NonText" })

-- Inactive statusbars: make a thin rule; align vertsplit to match.
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", underline = true })
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

-- My custom winbar
vim.api.nvim_set_hl(0, "Winbar", { link = "Comment" })

vim.api.nvim_set_hl(0, "ErrorWinbarDiagIndic", { link = "DiagnosticError" })
vim.api.nvim_set_hl(0, "WarnWinbarDiagIndic", { link = "DiagnosticWarn" })
vim.api.nvim_set_hl(0, "InfoWinbarDiagIndic", { link = "DiagnosticInfo" })
vim.api.nvim_set_hl(0, "HintWinbarDiagIndic", { link = "DiagnosticHint" })
vim.api.nvim_set_hl(0, "OkWinbarDiagIndic", { link = "DiagnosticOk" })

--
-- Configuration that needs Kitty to work
--
if string.find(vim.env.TERM, "xterm-kitty", 1, true) ~= nil then

    -- Diagnostics: use undercurl instead of underline where possible
    -- NOTE: Lua API is unusable because it changes ALL attributes of the highlight
    vim.cmd [[
        highlight DiagnosticUnderlineError gui=undercurl
        highlight DiagnosticUnderlineWarn gui=undercurl
        highlight DiagnosticUnderlineInfo gui=undercurl
        highlight DiagnosticUnderlineHint gui=undercurl
    ]]
end
