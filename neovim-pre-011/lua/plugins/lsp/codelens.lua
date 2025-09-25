local M = {}

function M.on_attach(client, buf)
    if client.server_capabilities.codeLensProvider then
        vim.api.nvim_create_autocmd({"BufEnter", "CursorHold", "InsertLeave"}, {
            group = vim.api.nvim_create_augroup("LspCodeLens." .. buf, {}),
            buffer = buf,
            callback = function()
                vim.lsp.codelens.refresh({ bufnr = 0 })
            end,
        })
    end
end

return M
