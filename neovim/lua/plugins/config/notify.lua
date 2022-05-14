local M  = { }

M.config = function ()
    local notify = require("notify")
    notify.setup({
        background_colour = "#2E3440",
    })
    vim.notify = notify
end

return M
