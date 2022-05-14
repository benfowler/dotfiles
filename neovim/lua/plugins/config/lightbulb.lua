local M = { }

M.config = function()
    -- stylua: ignore
    vim.cmd [[
        augroup customisation_plugin_lightbulb
            autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
            au ColorScheme * highlight LightBulbFloatWin ctermfg= ctermbg= guifg= guibg=
            au ColorScheme * highlight LightBulbVirtualText ctermfg= ctermbg= guifg= guibg=
            sign define LightBulbSign text=ﯧ texthl=DiagnosticWarn linehl= numhl=
        augroup END
    ]]
end

return M

