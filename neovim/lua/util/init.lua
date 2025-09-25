-- Useful utility functions used throughout this project.

local M = {}

-- Diagnostic icons
M.diagnostic_icons = {
    filled = {
        error = "󰅙",
        warn = "",
        info = "",
        hint = "󰌵",
    },
    outline = {
        error = "󰅚",
        warn = "",
        info = "",
        hint = "",
    },
}

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local buffer = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            on_attach(client, buffer)
        end,
    })
end

---@param plugin string
function M.has(plugin)
    return require("lazy.core.config").plugins[plugin] ~= nil
end

return M
