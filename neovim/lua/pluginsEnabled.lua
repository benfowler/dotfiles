local M = {}

-- enable and disable plugins (false for disable)
M.plugin_status = {
   -- UI
   nvim_bufferline = true,
   galaxyline = true,
   nvim_colorizer = true,
   dashboard_nvim = true,
   blankline = true,
   truezen_nvim = true,
   better_esc = true,
   vim_tmux_navigator = true,
   -- lsp stuff
   lspkind = true,
   lspsignature = true,
   -- git stuff
   gitsigns = true,
   vim_fugitive = true,
   -- misc
   neoformat = true,
   vim_matchup = true,
   autosave_nvim = true,
   nvim_comment = true,
   neoscroll_nvim = true,
   ultisnips = true,
   cheatsheet = true,
}

return M
