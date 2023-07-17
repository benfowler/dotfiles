return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufRead" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag"
    },
    opts = {
      ensure_installed = {
        "bash", "html", "java", "javascript", "lua", "python", "scala", "tsx", "vue"
        -- or "all" (not recommended)
      },
      autotag = {
        enable = true,
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
    }
  },
}
