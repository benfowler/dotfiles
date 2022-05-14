local present, fidget = pcall(require, "fidget")

if not present then
    return
end

fidget.setup {
    text = {
        spinner = "dots",
        done = " ",
    },
    timer = {
        fidget_decay = 3600,
        task_decay = 1800,
    },
    window = {
        blend = 5,
    },
}

local u = require "utils"
u.Hi("FidgetTitle", { gui = "bold", guifg = "#b48ead", guibg = "#2e3440" })
u.Hi("FidgetTask", { guifg = "#616e88", guibg = "#2e3440" })
