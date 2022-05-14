local present, notify = pcall(require, "notify")
if not present then
    return
end

notify.setup {
    background_colour = "#2E3440",
}
vim.notify = notify
