return {
    {
        "nvim-treesitter/nvim-treesitter",
        enabled = false,
        build = ":TSUpdate",
        event = { "BufRead" },
        opts = {
            ensure_installed = {
                "bash",
                "html",
                "java",
                "javascript",
                "lua",
                "python",
                "scala",
                "tsx",
                "vue",
                "xml",
                -- or "all" (not recommended)
            },
            highlight = {
                enable = true,
                use_languagetree = true,
            },
            indent = {
                enable = true,
            },
            matchup = {
                enable = true,
            },
        },
    },
}
