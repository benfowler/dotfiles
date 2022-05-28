local M = {}

local is_schemastore_loaded, schemastore = pcall(require, "schemastore")

if is_schemastore_loaded then
  M.get_lspconfig_settings = function(on_attach, capabilities, debounce_msec)
    return {
      settings = {
        json = {
          schemas = schemastore.json.schemas(),

          -- (or to tailor behaviour:)

          -- schemas = schemastore.json.schemas {
          --   select = {
          --     ".eslintrc",
          --     "package.json",
          --   },
          --   replace = {
          --     ["package.json"] = {
          --       description = "package.json overriden",
          --       fileMatch = { "package.json" },
          --       name = "package.json",
          --       url = "https://example.com/package.json",
          --     },
          --   },
          --   ignore = {
          --     ".eslintrc",
          --     "package.json",
          --   },
          -- },

          validate = { enable = true },
        },
      },
      on_attach = on_attach,
      capabilities = capabilities,
      root_dir = vim.loop.cwd,
      flags = { debounce_text_changes = debounce_msec },
    }
  end
else
  M.get_lspconfig_settings = function(on_attach, capabilities, debounce_msec)
    return {
      on_attach = on_attach,
      capabilities = capabilities,
      root_dir = vim.loop.cwd,
      flags = { debounce_text_changes = debounce_msec },
    }
  end
end

return M
