-- Useful utility functions used throughout this project.

local M = {}

-- Globals - usable from command mode

-- put(): shorthand for print(vim.inspect(...))
function _G.put(...)
    local objects = {}
    for i = 1, select("#", ...) do
        local v = select(i, ...)
        table.insert(objects, vim.inspect(v))
    end

    print(table.concat(objects, "\n"))
    return ...
end

-- Diagnostic icons
M.diagnostic_icons = {
    filled = {
        error = "󰅙",
        warn = "",
        info = "",
        hint = "󰌵",
    },
    outline = {
        error = "󰅚",
        warn = "",
        info = "",
        hint = "",
    },
}

return M
