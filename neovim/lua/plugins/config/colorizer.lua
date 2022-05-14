local present, colorizer = pcall(require, "colorizer")

if not present then
    return
end

colorizer.setup({
    "*",
    css = { css = true },
    html = { css = true },
}, {

    RRGGBB = true,
    RGB = false,
    names = false,
})
