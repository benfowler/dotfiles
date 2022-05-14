local present, ts_config = pcall(require, "nvim-treesitter.configs")
if not present then
    return
end

ts_config.setup {
    ensure_installed = { "python", "lua" }, -- or "all" (not recommended)
    highlight = {
        enable = true,
        disable = { "latex", "markdown" },
        use_languagetree = true,
    },
    indent = {
        enable = true,
    },
}
