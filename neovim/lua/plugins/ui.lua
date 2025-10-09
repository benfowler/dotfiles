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

    {
        "kyazdani42/nvim-tree.lua",
        cmd = { "NvimTreeToggle", "NvimTreeFocus" },
        keys = {
            { maps.nvimtree.treetoggle, ":NvimTreeToggle<CR>", silent = true, desc = "NvimTree goggle" },
            { maps.nvimtree.treefocus, ":NvimTreeFocus<CR>", silent = true, desc = "NvimTree focus file" },
        },
        opts = {
            respect_buf_cwd = true,
            view = {
                width = 30,
            },
            renderer = {
                add_trailing = true,
                group_empty = true,
                highlight_git = true,
                indent_markers = {
                    enable = false,
                },
                icons = {
                    show = {
                        git = false,
                    },
                    glyphs = {
                        git = {
                            unstaged = "",
                            staged = "",
                            unmerged = "",
                            renamed = "➜",
                            untracked = "★",
                            deleted = "",
                            ignored = "◌",
                        },
                    },
                },
                special_files = { "Cargo.toml", "Makefile", "pom.xml", "package.json", "Dockerfile" },
            },
            update_focused_file = {
                enable = true,
                update_cwd = false,
                ignore_list = {},
            },
            system_open = {
                cmd = nil,
                args = {},
            },
            diagnostics = {
                enable = true,
                icons = {
                    error = require("util").diagnostic_icons.outline.error,
                    warning = require("util").diagnostic_icons.outline.warn,
                    info = require("util").diagnostic_icons.outline.info,
                    hint = require("util").diagnostic_icons.outline.hint,
                },
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

    -- Popup keymapping help
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            -- Set a custom delay in milliseconds
            delay = 1500,
        },
    },

    -- Make to-dos stand out using custom highlights
    {
        "folke/todo-comments.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = "nvim-lua/plenary.nvim",
        opts = {
            keywords = {
                FIX = {
                    icon = " ", -- icon used for the sign, and in search results
                    color = "error", -- can be a hex color, or a named color (see below)
                    alt = { "FIXME", "BUG", "FIXIT", "ISSUE", "DANGER" }
                }
            },
            highlight = {
                pattern = { [[.*<(KEYWORDS)\s*:]], [[.*!!! <(KEYWORDS)\s*]] },
                comments_only = false,
            },
        },
    },

    -- Icons
    {
        "nvim-tree/nvim-web-devicons",
    },

}
