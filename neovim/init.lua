if vim.loader then
  vim.loader.enable()
else
  -- Only warn if Lua plugin cache is somehow broken
  vim.schedule(function()
    vim.notify("nvim cache is enabled")
  end)
end

require("config.options")
require("config.keymaps")
require("config.autocmds")

require("local.statusline")
require("local.winbar")
require("local.codelens")

-- vim.g.profile_loaders = true
require("config.lazy")({
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
})


