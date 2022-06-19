local M = {}

M.get_lspconfig_settings = function(on_attach, capabilities, debounce_msec)
    return {
        filetypes = { "html", "xml", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
        on_attach = on_attach,
        capabilities = capabilities,
        root_dir = vim.loop.cwd,
        flags = { debounce_text_changes = debounce_msec },
    }
end

return M
