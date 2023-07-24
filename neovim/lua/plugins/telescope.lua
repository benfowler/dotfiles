local maps = require "config.keymaps"

return {
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        dependencies = {
            "plenary.nvim",

            -- Extensions
            "crispgm/telescope-heading.nvim",
            "benfowler/telescope-luasnip.nvim",
        },
        opts = {
            defaults = {
                prompt_prefix = "   ",
                selection_caret = "❯ ",
                path_display = { "smart" },
                color_devicons = true,
                sort_lastused = true,
            },
            extensions = {
                fzf = {
                    fuzzy = true, -- false will only do exact matching
                    override_generic_sorter = false, -- override the generic sorter
                    override_file_sorter = true, -- override the file sorter
                    case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                    -- the default case_mode is "smart_case"
                },
            },
        },
        -- stylua: ignore
        keys = {
            -- Fast shortcuts to core Vim state
            { maps.telescope.telescope, ":Telescope<CR>", desc = "Telescope" },
            { maps.telescope.files, ":Telescope find_files<CR>", desc = "Fuzzy finder" },
            { maps.telescope.buffers, ":Telescope buffers<CR>", desc = "Buffers" },
            { maps.telescope.marks, ":Telescope marks<CR>", desc = "Marks" },
            { maps.telescope.registers, ":Telescope registers<CR>", desc = "Registers" },
            { maps.telescope.jumplist, ":Telescope jumplist<CR>", desc = "Jumplist" },
            { maps.telescope.help_tags, ":Telescope help_tags<CR>", desc = "Help tags" },
            { maps.telescope.man_pages, ":Telescope man_pages<CR>", desc = "Man pages" },
            { maps.telescope.keymaps, ":Telescope keymaps<CR>", desc = "Keymaps" },
            { maps.telescope.highlights, ":Telescope highlights<CR>", desc = "Highlights" },
            { maps.telescope.autocommands, ":Telescope autocommands<CR>", desc = "Autocmds" },

            -- Pick snippet to preview and insert
            { maps.telescope.select_snippet, ":Telescope luasnip theme=dropdown layout_config={'height':0.5,'width':120}<CR>", desc = "Telescope pick snippet", silent = true },

            -- LSP
            { maps.telescope.lsp_diagnostics, ":Telescope diagnostics theme=dropdown<CR>", desc = "Diagnostics" },
            { maps.telescope.lsp_diagnostics_doc, ":Telescope diagnostics theme=dropdown bufnr=0<CR>", desc = "Diagnostics document", },

            { maps.telescope.lsp_symbols, ":Telescope lsp_workspace_symbols theme=ivy<CR>", desc = "Symbols" },
            { maps.telescope.lsp_symbols_doc, ":Telescope lsp_document_symbols theme=ivy<CR>", desc = "Symbols" },

            { maps.telescope.lsp_definitions, ":Telescope lsp_definitions theme=ivy<CR>", desc = "Definitions" },
            { maps.telescope.lsp_implementations, ":Telescope lsp_implementations theme=ivy<CR>", desc = "Implementations", },
            { maps.telescope.lsp_references, ":Telescope lsp_references theme=ivy<CR>", desc = "References" },
            { maps.telescope.lsp_type_definitions, ":Telescope lsp_type_definitions theme=ivy<CR>", desc = "Type definitions", },

            -- Git objects
            { maps.telescope.git_commits, ":Telescope git_commits theme=ivy<CR>", desc = "Git commits" },
            { maps.telescope.git_bcommits, ":Telescope git_bcommits theme=ivy<CR>", desc = "Git branch commits" },
            { maps.telescope.git_branches, ":Telescope git_branches theme=ivy<CR>", desc = "Git branches" },
            { maps.telescope.git_stash, ":Telescope git_stash theme=ivy<CR>", desc = "Git stashes" },
            { maps.telescope.git_files, ":Telescope git_files<CR>", desc = "Git files" },

            -- Markdown headings navigation
            { maps.telescope.markdown_headings, ":Telescope heading theme=dropdown<cr>", desc = "Headings (Telescope)", },

            -- Use Telescope to pick spelling suggestions
            { maps.telescope.spell_suggest, ":Telescope spell_suggest theme=cursor<CR>", desc = "Telescope spell suggest", silent = true, },
        },
        config = function()
            require("telescope").load_extension "heading"
            require("telescope").load_extension "luasnip"
        end,
    },
}
