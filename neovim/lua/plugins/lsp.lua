return {

    -- nvim-lspconfig (for canned configs only; requires v0.11+)
    {
        "neovim/nvim-lspconfig",
        lazy = false,
    },

    -- Show LSP server activity as an overlay
    {
        "j-hui/fidget.nvim",
        lazy = false,
        opts = {
            notification = {
                window = {
                    winblend = 0,
                },
            },
        },
    },

    -- Core Copilot integration
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            -- Disable native ghost text UI modules to prevent overlapping renders
            suggestion = { enabled = false },
            panel = { enabled = false },
            filetypes = {
                ["*"] = true,
                -- Disable Copilot in certain filetypes
                ["TelescopePrompt"] = false,
                ["NvimTree"] = false,
                ["markdown"] = false,
                ["text"] = false,
            },
        },
    },

    -- Use blink.cmp for fuzzy autocomplete in LSP
    {
        "saghen/blink.cmp",
        version = "v1.10.2", -- pin this to a release to keep running; use pre-built fuzzy finder binary
        dependencies = { "fang2hou/blink-copilot" },
        opts = {

            -- Menu formatting and colorisation
            appearance = {
                nerd_font_variant = "mono",
            },

            -- General completion options
            completion = {
                accept = { auto_brackets = { enabled = true } },

                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 250,
                    treesitter_highlighting = true,
                    window = { border = "rounded" },
                },

                ghost_text = {
                    enabled = true,
                    show_with_menu = false, -- only show when menu is closed
                },

                menu = {
                    auto_show = false,
                    draw = {
                        columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 } },
                    },
                    max_height = 15,
                    winblend = 5,
                },
            },

            -- Register Copilot as a backend completion provider
            sources = {
                default = function()
                    local ok = pcall(require, "copilot")
                    if ok then
                        return { "lsp", "path", "snippets", "buffer", "copilot" }
                    else
                        return { "lsp", "path", "snippets", "buffer" }
                    end
                end,
                providers = {
                    copilot = {
                        name = "copilot",
                        module = "blink-copilot",
                        score_offset = 100, -- Forces Copilot to the top for instant ghost text
                        async = true,
                        opts = {
                            max_completions = 3,
                        }
                    },
                },
            },

            -- Enable snippet support (requires luasnip or mini.snippets)
            snippets = {
                preset = "luasnip",
            },
        },
    },

    -- Show code action signs
    {
        "kosayoda/nvim-lightbulb",
        lazy = false,
        opts = {
            sign = {
                text = " ",
                hl = "DiagnosticSignWarn",
            },
            autocmd = {
                enabled = true,
            },
            config = function()
                require("nvim-lightbulb").setup({
                    autocmd = { enabled = true }
                })
            end,
        },
    },
}
