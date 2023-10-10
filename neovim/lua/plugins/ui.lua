local maps = require "config.keymaps"

return {
    -- Better `vim.notify()`
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        init = function()
            vim.notify = require "notify"
        end,
        keys = {
            {
                maps.notify.delete_all,
                function()
                    require("notify").dismiss { silent = true, pending = true }
                end,
                desc = "Delete all notifications",
            },
        },
        opts = {
            timeout = 3000,
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.75)
            end,
        },
    },

    -- Better vim.ui
    {
        "stevearc/dressing.nvim",
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load { plugins = { "dressing.nvim" } }
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load { plugins = { "dressing.nvim" } }
                return vim.ui.input(...)
            end
        end,
        opts = {
            input = {
                win_options = {
                    winblend = 0,
                    winhighlight = "FloatBorder:DressingFloatBorder",
                },
            },
            select = {
                get_config = function(opts)
                    if opts.kind == 'codeaction' then
                        return {
                            backend = 'telescope',
                            telescope = require('telescope.themes').get_cursor()
                        }
                    end
                end
            },
        },
    },

    -- Indent guides
    {
        "lukas-reineke/indent-blankline.nvim",
        version = "2.20.8",
        event = { "BufRead" },
        opts = {
            char = "│",
            space_char_blankline = " ",
            show_first_indent_level = false,
            show_trailing_blankline_indent = false,
            max_indent_increase = 1,
            filetype_exclude = {
                "startify",
                "dashboard",
                "dotooagenda",
                "log",
                "fugitive",
                "gitcommit",
                "packer",
                "vimwiki",
                "markdown",
                "txt",
                "vista",
                "help",
                "todoist",
                "NvimTree",
                "peekaboo",
                "git",
                "TelescopePrompt",
                "undotree",
                "flutterToolsOutline",
                "", -- for all buffers without a file type
            },
            buftype_exclude = { "terminal", "nofile" },
            show_current_context = true,
            context_patterns = {
                "class",
                "function",
                "method",
                "block",
                "list_literal",
                "selector",
                "^if",
                "^table",
                "if_statement",
                "while",
                "for",
            },
        },
    },

    -- Make to-dos stand out using custom highlights
    {
        "folke/todo-comments.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = "nvim-lua/plenary.nvim",
        opts = {
            highlight = {
                comments_only = false
            }
        },
    },

    -- Popup keymapping help
    {
        "folke/which-key.nvim",
        lazy = false,
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 750

            local wk = require "which-key"
            wk.setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
            }

            -- Apply customised labels to groups
            wk.register(require("config.keymaps").which_key_groups)
        end,
    },

    -- Focus mode
    {
        "folke/zen-mode.nvim",
        cmd = "ZenMode",
        keys = {
            { maps.zenmode.toggle_zenmode, ":ZenMode<CR>", desc = "Zen mode" },
        },
        opts = {
            window = {
                backdrop = 1,
                options = {
                    number = false,
                    relativenumber = false,
                    foldcolumn = "0",
                },
            },
            plugins = {
                gitsigns = { enabled = true },
                tmux = { enabled = true },
                kitty = {
                    enabled = true,
                    font = "+2", -- font size increment
                },
            },
        },
    },

    -- Icons
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },

    -- Debug slow startup
    {
        "dstein64/vim-startuptime",
        lazy = false,
    },
}
