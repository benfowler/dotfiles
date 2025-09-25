local maps = require "config.keymaps"

return {
    {
        "christoomey/vim-tmux-navigator",
        init = function()
            vim.g.tmux_navigator_no_mappings = 1
        end,
        keys = {
            -- stylua: ignore start
            { maps.tmuxnavigator.pane_left, ":TmuxNavigateLeft<CR>", silent = true, desc = "Nav Left Split/Pane" },
            { maps.tmuxnavigator.pane_down, ":TmuxNavigateDown<CR>", silent = true, desc = "Nav Down Split/Pane" },
            { maps.tmuxnavigator.pane_up, ":TmuxNavigateUp<CR>", silent = true, desc = "Nav Up Split/Pane" },
            { maps.tmuxnavigator.pane_right, ":TmuxNavigateRight<CR>", silent = true, desc = "Nav Right Split/Pane", },

            { maps.tmuxnavigator.pane_left, "<C-\\><C-n>:TmuxNavigateLeft<CR>", mode = "t", silent = true, desc = "Nav Left Split/Pane", },
            { maps.tmuxnavigator.pane_down, "<C-\\><C-n>:TmuxNavigateDown<CR>", mode = "t", silent = true, desc = "Nav Down Split/Pane", },
            { maps.tmuxnavigator.pane_up, "<C-\\><C-n>:TmuxNavigateUp<CR>", mode = "t", silent = true, desc = "Nav Up Split/Pane", },
            { maps.tmuxnavigator.pane_right, "<C-\\><C-n>:TmuxNavigateRight<CR>", mode = "t", silent = true, desc = "Nav Right Split/Pane", },
            -- stylua: ignore end
        },
    },
}
