return {

    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        dependencies = {
            { "windwp/nvim-ts-autotag" },
        },
        config = function()
            require('nvim-treesitter').install({
                "bash",
                "html",
                "java",
                "javascript",
                "json",
                "kotlin",
                "lua",
                "python",
                "scala",
                "toml",
                "tsx",
                "typescript",
                "vue",
                "xml",
                "yaml"
             })
        end,
    },

    {
        -- XML autocomplete
        "windwp/nvim-ts-autotag",
        config = function()
            require("nvim-ts-autotag").setup()
        end,
    },

}
