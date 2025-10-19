return {

    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",
        dependencies = {
            { "windwp/nvim-ts-autotag" },
        },
        config = function()
            require("nvim-treesitter.configs").setup {

                ensure_installed = {
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
                    "yaml",
                    -- or "all" (not recommended)
                },
                sync_install = false,
                highlight = {
                    enable = true,
                    disable = { "markdown" },
                },
                indent = {
                    enable = true,
                    disable = {
                        "markdown", -- indentation at bullet points is worse
                    },
                },
                matchup = {
                    enable = true,
                },
            }
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
