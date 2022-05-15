local M = {}

M.configure = function(on_attach, capabilities, debounce_msec)
    return {
        settings = {
            showImplicitArguments = true,
        },
        filetypes = { "scala", "sbt" },
        on_attach = on_attach,
        capabilities = capabilities,
        root_dir = vim.loop.cwd,
        flags = { debounce_text_changes = debounce_msec },
    }
end

return M
