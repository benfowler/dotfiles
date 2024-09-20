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
                    if opts.kind == "codeaction" then
                        return {
                            backend = "telescope",
                            telescope = require("telescope.themes").get_cursor(),
                        }
                    end
                end,
            },
        },
    },

    -- Indent guides
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = { "BufRead" },
        config = function()
            require("ibl").setup({
                indent = { char = "┊" },
                scope = {
                    include = {
                        node_type = {
                            "class", "function", "method", "block", "list_literal", "selector",
                            "^if", "^table", "if_statement", "while", "for"
                        }
                    }
                },
                exclude = {
                    filetypes = {
                        "startify", "dashboard", "dotooagenda", "log", "fugitive", "gitcommit",
                        "packer", "vimwiki", "txt", "vista", "help", "todoist", "NvimTree",
                        "peekaboo", "git", "TelescopePrompt", "undotree", "flutterToolsOutline",
                        ""  -- for all buffers without a file type
                    },
                    buftypes = { "terminal", "nofile" }
                }
            })

            local hooks = require("ibl.hooks")
            hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
        end
    },

    -- Set up statuscolumn with click handlers
    {
        "luukvbaal/statuscol.nvim",
        lazy = false,
        config = function()
            local builtin = require("statuscol.builtin")
            require("statuscol").setup {
                relculright = true,
                segments = {
                    { text = { builtin.lnumfunc }, click = "v:lua.ScLa" },
                    {
                        sign = { namespace = { "diagnostic", "gitsigns" }, name = { ".*" }, maxwidth = 1, colwidth = 1, auto = true, wrap = true },
                        click = "v:lua.ScSa",
                    },
                    {
                        text = { builtin.foldfunc, " " },
                        click = "v:lua.ScFa",
                    },
                },
            }
        end,
    },

    -- Better folding
    {
        "kevinhwang91/nvim-ufo",
        event = { "BufRead" },
        dependencies = "kevinhwang91/promise-async",
        config = function ()
            require("ufo").setup({
                provider_selector = function(_, _, _)
                    return {"treesitter", "indent"}
                end
            })

            vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
            vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
            vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
        end
    },

    -- Make to-dos stand out using custom highlights
    {
        "folke/todo-comments.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = "nvim-lua/plenary.nvim",
        opts = {
            highlight = {
                comments_only = false,
            },
        },
    },

    -- Popup keymapping help
    {
        "folke/which-key.nvim",
        lazy = false,
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 2000

            local wk = require "which-key"
            wk.add(require("config.keymaps").which_key_groups)
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
    },

    {
        "echasnovski/mini.icons",
    },

    -- Debug slow startup
    {
        "dstein64/vim-startuptime",
        lazy = false,
    },
}
