local present, dressing = pcall(require, "dressing")

if not present then
    return
end

dressing.setup {
    input = {
        win_options = {
            winblend = 0,
            winhighlight = "FloatBorder:DressingFloatBorder",
        }
    },
    select = {
        backend = { "telescope" },
        builtin = {
            min_height = { 3 },
            relative = "cursor",
            win_options = {
                winblend = 0,
                winhighlight = "FloatBorder:DressingFloatBorder",
            },
        },
    },
}
