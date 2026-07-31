
return {

    -- nvim-lspconfig (for canned configs only; requires v0.11+)
    {
        "neovim/nvim-lspconfig",
        lazy=false,
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

    -- Use blink.cmp for fuzzy autocomplete in LSP
    {
        "saghen/blink.cmp",
        version = "v1.10.2",  -- pin this to a release to keep running; use pre-built fuzzy finder binary
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

            -- Enable snippet support (requires luasnip or mini.snippets)
            snippets = {
                preset = "luasnip",
            },

            -- Enable function signature help
            signature = {
                enabled = true,
                window = { border = "rounded" },
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
