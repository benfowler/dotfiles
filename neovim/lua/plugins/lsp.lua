
return {
    -- Show LSP server activity as an overlay
    {
        "j-hui/fidget.nvim",
        lazy = false,
        opts = { },
    },

    -- Use blink.cmp for fuzzy autocomplete in LSP
    {
        "saghen/blink.cmp",
        build = 'cargo build --release',
        opts = {
            -- General completion options
            completion = {
                ghost_text = {
                    enabled = true,
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
        },
    },
}
