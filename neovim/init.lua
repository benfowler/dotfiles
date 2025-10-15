if vim.loader then
    vim.loader.enable()
else
    -- Only warn if Lua plugin cache is somehow broken
    vim.schedule(function()
        vim.notify "nvim cache is broken -- please check"
    end)
end

require "local.statusline"
require "local.winbar"

require "config.options"
require "config.autocmds"
require "config.keymaps"
require "config.lsp"

-- vim.g.profile_loaders = true
require "config.lazy" {
    debug = false,
    defaults = {
        lazy = true,
        -- cond = false,
    },
    performance = {
        cache = {
            enabled = true,
        },
    },
}

require "local.qf"
require "local.highlights"  -- apply highlights as late as possible
