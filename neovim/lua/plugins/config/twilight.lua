local present, twilight = pcall(require, "twilight")
if not present then
    return
end

twilight.setup {
    dimming = {
        alpha = 0.5,
        context = 15,
        inactive = true,
    },
}
