
-- Inactive statusbars: make a thin rule; align vertsplit to match.
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", underline = true })
vim.api.nvim_set_hl(0, "VertSplit", { link = "NonText" })
vim.api.nvim_set_hl(0, "WinSeparator", { link = "NonText" })

-- My custom winbar
vim.api.nvim_set_hl(0, "Winbar", { link = "Comment" })

vim.api.nvim_set_hl(0, "ErrorWinbarDiagIndic", { link = "DiagnosticError" })
vim.api.nvim_set_hl(0, "WarnWinbarDiagIndic", { link = "DiagnosticWarn" })
vim.api.nvim_set_hl(0, "InfoWinbarDiagIndic", { link = "DiagnosticInfo" })
vim.api.nvim_set_hl(0, "HintWinbarDiagIndic", { link = "DiagnosticHint" })
vim.api.nvim_set_hl(0, "OkWinbarDiagIndic", { link = "DiagnosticOk" })

-- VS Code-coloured kind icons for nvim-cmp
-- gray
vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', { bg='NONE', strikethrough=true, fg='#808080' })
-- blue
vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { bg='NONE', fg='#569CD6' })
vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { link='CmpIntemAbbrMatch' })
-- light blue
vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { bg='NONE', fg='#9CDCFE' })
vim.api.nvim_set_hl(0, 'CmpItemKindInterface', { link='CmpItemKindVariable' })
vim.api.nvim_set_hl(0, 'CmpItemKindText', { link='CmpItemKindVariable' })
-- pink
vim.api.nvim_set_hl(0, 'CmpItemKindFunction', { bg='NONE', fg='#C586C0' })
vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { link='CmpItemKindFunction' })
-- front
vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { bg='NONE', fg='#D4D4D4' })
vim.api.nvim_set_hl(0, 'CmpItemKindProperty', { link='CmpItemKindKeyword' })
vim.api.nvim_set_hl(0, 'CmpItemKindUnit', { link='CmpItemKindKeyword' })

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
