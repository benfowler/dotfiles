return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
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
                    "lua",
                    "python",
                    "scala",
                    "toml",
                    "tsx",
                    "vue",
                    "xml",
                    "yaml",
                    -- or "all" (not recommended)
                },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
                matchup = { enable = true, }
            })
        end
    }
}
