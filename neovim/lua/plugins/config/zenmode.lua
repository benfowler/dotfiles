local present, zen_mode = pcall(require, "zen-mode")
if not present then
    return
end

zen_mode.setup {
    window = {
        backdrop = 1,
        options = {
            number = false,
            relativenumber = false,
            foldcolumn = "0",
        },
    },
    plugins = {
        gitsigns = { enabled = true },
        tmux = { enabled = true },
        kitty = {
            enabled = true,
            font = "+2", -- font size increment
        },
    },
}
