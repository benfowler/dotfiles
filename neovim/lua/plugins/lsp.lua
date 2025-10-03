
return {
    -- Show LSP server activity as an overlay
    {
        "j-hui/fidget.nvim",
        lazy = false,
        opts = { },
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
