local maps = require "config.keymaps"

return {

    -- OneDark theme
    {
        "navarasu/onedark.nvim",
        lazy = false,
        priority = 1000,
        init = function()
            require "onedark".load()
            require "local.highlights"   -- highlights need reapplying
        end,
        opts = {
            style = "darker"
        }
    },

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

    -- Icons
    {
        "nvim-tree/nvim-web-devicons",
    },

}
