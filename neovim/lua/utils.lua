-- Useful utility functions used throughout this project.

local M = {}

-- Utility method to make setting highlights not suck
M.Hi = function(group, opts)
    local c = "highlight " .. group
    for k, v in pairs(opts) do
        c = c .. " " .. k .. "=" .. v
    end
    vim.cmd(c)
end

M.HiLink = function(group, linked_to_group, is_forced)
    local c = "highlight" .. (is_forced and "!" or "") .. " link " .. group .. " " .. linked_to_group
    vim.cmd(c)
end

M.HiClear = function(name)
    local c = "highlight clear " .. name
    vim.cmd(c)
end

return M
