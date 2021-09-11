local M = {}

-- enable and disable plugins (true for disable)
M.plugin_status = {
    -- UI
    nvim_colorizer = true,
    truezen_nvim = true,
    vim_tmux_navigator = true,
    statusline = true,
    nord = true,
    telescope = true,
    fzf = true,
    -- lsp stuff
    lspsignature = true,
    -- git stuff
    gitsigns = true,
    vim_fugitive = true,
    -- misc
    nvim_comment = true,
}

return M
