local present, ts_config = pcall(require, "nvim-treesitter.configs")
if not present then
    return
end

ts_config.setup {
    ensure_installed = { "bash", "html", "java", "javascript", "lua", "python", "scala", "tsx", "vue" }, -- or "all" (not recommended)
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
}
