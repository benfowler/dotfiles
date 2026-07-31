
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
            -- General completion options
            completion = {
                menu = {
                    auto_show = false,
                },
                ghost_text = {
                    enabled = true,
                    show_with_menu = false, -- only show when menu is closed
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
