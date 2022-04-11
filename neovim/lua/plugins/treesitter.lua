local present, ts_config = pcall(require, "nvim-treesitter.configs")
if not present then
    return
end

ts_config.setup {
    ensure_installed = { "python", "lua", "markdown" }, -- or "all" (not recommended)
    highlight = {
        enable = true,
        disable = { "latex" },
        use_languagetree = true,
    },
    indent = {
        enable = true,
    },
}
