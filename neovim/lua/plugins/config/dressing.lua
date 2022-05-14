local M = { }

M.config = function()
    require("dressing").setup({
        input = {
            winblend = 0,
            winhighlight = "FloatBorder:DressingFloatBorder",
        },
    })
end

return M

