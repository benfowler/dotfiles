return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function ()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = {
                    "bash",
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
                sync_install = false,
                highlight = {
                    enable = true,
                    disable = { "markdown" }
                },
                indent = {
                    enable = true,
                },
                matchup = {
                    enable = true,
                }
            })
        end
    }
}
