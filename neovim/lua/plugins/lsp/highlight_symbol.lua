local M = {}

local cmp_available, cmp = pcall(require, "cmp")

function M.on_attach(client, bufnr)
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_augroup("lsp_document_highlight", {
            clear = false,
        })
        vim.api.nvim_clear_autocmds {
            buffer = bufnr,
            group = "lsp_document_highlight",
        }
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = "lsp_document_highlight",
            buffer = bufnr,
            callback = function ()
                if cmp_available and cmp.visible() then return end   -- don't mess up nvim-cmp ghost text
                vim.lsp.buf.document_highlight()
            end,
        })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            group = "lsp_document_highlight",
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
        })
    end
end

return M
