local maps = require "config.keymaps"

return {
    {
        "tpope/vim-fugitive",
        cmd = { "G", "Git", "Gread", "Gwrite", "Gdiff" },
        keys = {
            { maps.fugitive.Git, ":Git<CR>", desc = "Open Fugitive" },
            -- { maps.fugitive.diffget_2, ":diffget //2<CR>", desc = "GitSigns Fugitive diff 2" },
            { maps.fugitive.diffget_3, ":diffget //3<CR>", desc = "Fugitive diff 3" },
            { maps.fugitive.git_blame, ":Git blame<CR>", desc = "Fugitive annotate" },
        },
        lazy = true,
    },

    {
        "kdheepak/lazygit.nvim",
        cmd = { "LazyGit" },
        keys = {
            { maps.lazygit.lazygit, ":LazyGit<CR>", desc = "Open LazyGit" },
        },
        lazy = true,
    },

    {
        "lewis6991/gitsigns.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        event = "BufRead",
        opts = {
            watch_gitdir = { interval = 2000, follow_files = true },
            sign_priority = 6,
            update_debounce = 100,
            status_formatter = nil, -- Use default
            max_file_length = 40000,
            preview_config = {
                border = "rounded",
                style = "minimal",
                relative = "cursor",
                noautocmd = true,
                row = 0,
                col = 1,
            },
        },
        keys = {
            {
                -- Navigation
                maps.gitsigns.next_hunk,
                function()
                    if vim.wo.diff then
                        return "]c"
                    end
                    vim.schedule(function()
                        require("gitsigns").next_hunk()
                    end)
                    return "<Ignore>"
                end,
                desc = "Next Git hunk",
                expr = true,
                silent = true,
            },
            {
                -- Navigation
                maps.gitsigns.prev_hunk,
                function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(function()
                        require("gitsigns").prev_hunk()
                    end)
                    return "<Ignore>"
                end,
                desc = "Previous Git hunk",
                expr = true,
                silent = true,
            },
            {
                maps.gitsigns.stage_hunk,
                function()
                    require("gitsigns").stage_hunk()
                end,
                desc = "Stage hunk",
                mode = { "n", "v" },
            },
            {
                maps.gitsigns.reset_hunk,
                function()
                    require("gitsigns").reset_hunk()
                end,
                desc = "Reset hunk",
                mode = { "n", "v" },
            },
            {
                maps.gitsigns.preview_hunk,
                function()
                    require("gitsigns").preview_hunk()
                end,
                desc = "Preview hunk",
            },
            {
                maps.gitsigns.blame_line,
                function()
                    require("gitsigns").blame_line { full = true }
                end,
                desc = "Blame line",
            },
            {
                maps.gitsigns.diffthis,
                function()
                    require("gitsigns").diffthis()
                end,
                desc = "Diff hunk",
            },
            {
                maps.gitsigns.undo_stage_hunk,
                function()
                    require("gitsigns").undo_stage_hunk()
                end,
                desc = "Undo stage hunk",
            },
            {
                maps.gitsigns.stage_buffer,
                function()
                    require("gitsigns").stage_buffer()
                end,
                desc = "Stage buffer",
            },
            {
                maps.gitsigns.reset_buffer,
                function()
                    require("gitsigns").reset_buffer()
                end,
                desc = "Reset buffer",
            },
            {
                maps.gitsigns.toggle_current_line_blame,
                function()
                    require("gitsigns").toggle_current_line_blame()
                end,
                desc = "Toggle line blame",
            },
            {
                maps.gitsigns.loclist,
                function()
                    require("gitsigns").setloclist "~"
                end,
                desc = "Loclist",
            },
            {
                maps.gitsigns.diffthis2,
                function()
                    require("gitsigns").diffthis "~"
                end,
                desc = "Diff",
            },
            {
                maps.gitsigns.preview_hunk,
                function()
                    require("gitsigns").toggle_deleted()
                end,
                desc = "Preview hunk",
            },
            {
                -- Text object
                maps.gitsigns.select_hunk_text_object,
                ":<C-U>Gitsigns select_hunk<CR>",
                mode = { "o", "x" },
                desc = "hunk",
            },
        },
    },
}
