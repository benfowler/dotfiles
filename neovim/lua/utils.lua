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
        error = "",
        warn = "",
        info = "",
        hint = "",
    },
    outline = {
        error = "",
        warn = "",
        info = "",
        hint = "",
    },
}

-- Set a highlight group
M.Hi = function(group, opts, is_forced)
    is_forced = is_forced or false
    local c = "highlight" .. (is_forced and "! " or " ") .. group
    for k, v in pairs(opts) do
        c = c .. " " .. k .. "=" .. v
    end
    vim.cmd(c)
end

-- Set a highlight group link
M.HiLink = function(group, linked_to_group, is_forced)
    is_forced = is_forced or false
    local c = "highlight" .. (is_forced and "!" or "") .. " link " .. group .. " " .. linked_to_group
    vim.cmd(c)
end

-- Clear a highlight group
M.HiClear = function(name)
    local c = "highlight clear " .. name
    vim.cmd(c)
end

-- Enable nvim-cmp autocompletion
M.EnableAutoCmp = function()
    local has_cmp, cmp = pcall(require, "cmp")
    if has_cmp then
        cmp.setup {
            completion = {
                autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
            },
        }
    end
end

-- Disable nvim-cmp autocompletion
M.DisableAutoCmp = function()
    local has_cmp, cmp = pcall(require, "cmp")
    if has_cmp then
        cmp.setup {
            completion = {
                autocomplete = false,
            },
        }
    end
end

-- GitSigns needs redrawing?
local flush_gitsigns = function()
    local has_gitsigns, _ = pcall(require, "gitsigns")
    local has_gitsigns_config, gitsigns_config = pcall(require, "plugins.config.gitsigns")

    if has_gitsigns and has_gitsigns_config then
        gitsigns_config.configure()
    end
end

-- Enable folding (and associated plugin)
M.EnableFolding = function()
    local has_ufo, ufo = pcall(require, "ufo")

    vim.opt.foldcolumn = "1"
    vim.opt.foldenable = true

    if has_ufo then
        ufo.enable()
        flush_gitsigns()
    end
end

-- Temporary command for testing of new folding
vim.api.nvim_create_user_command('EnableFolding', function() M.EnableFolding() end, { bang = false })

-- Disable folding (and associated plugin)
M.DisableFolding = function()
    local has_ufo, ufo = pcall(require, "ufo")

    vim.opt.foldcolumn = "0"
    vim.opt.foldenable = false

    if has_ufo then
        ufo.disable()
        flush_gitsigns()
    end
end

-- Temporary command for testing of new folding
vim.api.nvim_create_user_command('DisableFolding', function() M.DisableFolding() end, { bang = false })

return M
