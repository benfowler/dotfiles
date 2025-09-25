return {

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = {
            { "windwp/nvim-ts-autotag" },
        },
        config = function()
            local configs = require "nvim-treesitter.configs"

            configs.setup {
                ensure_installed = {
                    "bash",
                    "css",
                    "html",
                    "java",
                    "javascript",
                    "json",
                    "kotlin",
                    "latex",
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
                autotag = {
                    enable = true,
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
        lazy = false,
        config = function()
            require("nvim-ts-autotag").setup()
        end,
    },

}
