local lsp_status = require "lsp-status"

local M = {}

M.get_lspconfig_settings = function(on_attach, capabilities, debounce_chgs_msec)
    return {
        handlers = lsp_status.extensions.clangd.setup(),
        init_options = {
            clangdFileStatus = true,
        },
        on_attach = on_attach,
        capabilities = capabilities,
        flags = { debounce_text_changes = debounce_chgs_msec},
    }
end

return M
