local M = {}

M.configure = function(on_attach, capabilities, debounce_msec)
    return {
        settings = {
            Lua = {
                runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
                completion = { enable = true, callSnippet = "Both" },
                diagnostics = {
                    enable = true,
                    globals = { "vim", "describe" },
                    disable = { "lowercase-global" },
                },
                workspace = {
                    library = {
                        [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                        [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
                    },
                    maxPreload = 100000,
                    preloadFileSize = 10000,
                },
                telemetry = {
                    enable = false,
                },
            },
        },
        on_attach = on_attach,
        capabilities = capabilities,
        flags = { debounce_text_changes = debounce_msec },
    }
end

return M
