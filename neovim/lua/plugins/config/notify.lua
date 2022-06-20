local present, notify = pcall(require, "notify")
if not present then
    return
end

notify.setup {
    background_colour = "#2E3440",
    max_width = 80,
}

vim.notify = notify

vim.api.nvim_create_user_command(
    'NotificationsDismiss',
    function()
        notify.dismiss()
    end,
    { bang = true }
)
