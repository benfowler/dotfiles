local maps = require "config.keymaps"

return {
    {
        "junegunn/fzf.vim",
        dependencies = { "junegunn/fzf" },
        build = function()
            vim.cmd [[ call fzf#install() ]]
        end,
        -- stylua: ignore
        cmd = {
            "Files", "GFiles", "Buffers", "Colors", "Ag", "Rg", "Lines",
            "BLines", "Tags", "BTags", "Marks", "Windows", "Locate", "History",
            "History", "Snippets", "Commits", "BCommits", "Commands", "Maps",
            "Helptags", "Filetypes",
        },
        keys = {
            { maps.fzf.files, silent = true, ":Files<CR>", desc = "FZF Files" },
            { maps.fzf.gfiles, silent = true, ":GFiles<CR>", desc = "FZF GFiles" },
            { maps.fzf.history, silent = true, ":History<CR>", desc = "FZF History" },
            { maps.fzf.buffers, silent = true, ":Buffers<CR>", desc = "FZF Buffers" },
            { maps.fzf.ripgrep, silent = true, ":Rg<CR>", desc = "FZF RipGrep" },
        },
        config = function()
            -- General config options
            vim.g.fzf_buffers_jump = 1 -- jump to the existing window if possible
            vim.g.fzf_preview_window = "" -- none by default
            vim.g.fzf_prefer_tmux = 1

            -- FZF mode tweaks
            vim.env.FZF_DEFAULT_OPTS = " --layout=reverse --border --margin=1,1 --no-separator"

            -- This is the default extra key bindings
            vim.g.fzf_action = {
                ["ctrl-t"] = "tab split",
                ["ctrl-x"] = "split",
                ["ctrl-v"] = "vsplit",
            }

            -- Pull colours from current theme
            vim.g.fzf_colors = {
                ["fg"] = { "fg", "FzfFg" },
                ["bg"] = { "bf", "FzfBg" },
                ["hl"] = { "fg", "FzfHl" },
                ["fg+"] = { "fg", "FzfFg_" },
                ["bg+"] = { "bg", "FzfBg_" },
                ["hl+"] = { "fg", "FzfHl_" },
                ["info"] = { "fg", "FzfInfo" },
                ["border"] = { "fg", "FzfBorder" },
                ["prompt"] = { "fg", "FzfPrompt" },
                ["pointer"] = { "fg", "FzfPointer" },
                ["marker"] = { "fg", "FzfMarker" },
                ["spinner"] = { "fg", "FzfSpinner" },
                ["header"] = { "fg", "FzfHeader" },
            }

            -- Window setups for FZF
            vim.g.fzf_custom_win_files = {
                window = { width = 0.6, height = 0.75, border = "rounded", highlight = "Comment" },
            }

            vim.g.fzf_custom_win_buffers = {
                window = { width = 0.4, height = 0.5, border = "rounded", highlight = "Comment" },
                placeholder = "{1}",
            }

            vim.g.fzf_custom_win_windows = {
                window = { width = 0.4, height = 0.5, border = "rounded", highlight = "Comment" },
                placeholder = "{1}",
                options = "--prompt='Win> '",
            }

            vim.g.fzf_custom_win_grep = {
                window = { width = 0.9, height = 0.75, border = "rounded", highlight = "Comment" },
            }

            -- How are we invoking rg?
            vim.g.fzf_rg_cmd = "rg --column --line-number --no-heading --color=always --smart-case -- "

      -- stylua: ignore
      -- TODO: Port the following commands to Lua
      vim.cmd [[

        " Pop up Fuzzy Finder in a window when using Neovim
        command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, g:fzf_custom_win_files, <bang>0)
        command! -bang -nargs=? -complete=dir History call fzf#vim#history(g:fzf_custom_win_files, <bang>0)
        command! -bang -nargs=? -complete=dir GFiles call fzf#vim#gitfiles(<q-args>, g:fzf_custom_win_files, <bang>0)
        command! -bang -nargs=? -complete=dir GitFiles call fzf#vim#gitfiles(<q-args>, g:fzf_custom_win_files, <bang>0)
        command! -bang -nargs=? -complete=buffer Buffers call fzf#vim#buffers(<q-args>, g:fzf_custom_win_buffers, <bang>0)
        command! -bar -bang Windows call fzf#vim#windows(g:fzf_custom_win_windows, <bang>0)
        command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, g:fzf_custom_win_grep, <bang>0)
        command! -bang -nargs=* Rg call fzf#vim#grep( g:fzf_rg_cmd.shellescape(<q-args>), 1, g:fzf_custom_win_grep, <bang>0)
      ]]
        end,
    },
}
