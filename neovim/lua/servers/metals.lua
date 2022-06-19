local M = {}

--  See issue #17 on j-hui/figet.nvim
--  https://github.com/j-hui/fidget.nvim/issues/17

local function metals_status_handler(arg1, status, ctx)
    -- https://github.com/scalameta/nvim-metals/blob/main/lua/metals/status.lua#L36-L50
    local val = {}
    if status.hide then
        val = { kind = "end" }
    elseif status.show then
        val = { kind = "begin", message = status.text, title = "status" }
    elseif status.text then
        val = { kind = "report", message = status.text, title = "status" }
    else
        return
    end
    local info = { client_id = ctx.client_id }
    local msg = { token = "metals", value = val }
    -- call fidget progress handler
    vim.lsp.handlers["$/progress"](nil, msg, info)
end

local handlers = {}
handlers["metals/status"] = metals_status_handler

M.get_lspconfig_settings = function(on_attach, capabilities, debounce_msec)
    return {
        init_options = {
            -- default setting in lspconfig is "show-message"
            statusBarProvider = "on",
        },
        settings = {
            showImplicitArguments = true,
        },
        filetypes = { "scala", "sbt" },
        on_attach = on_attach,
        capabilities = capabilities,
        root_dir = vim.loop.cwd,
        handlers = handlers,
        flags = { debounce_text_changes = debounce_msec },
    }
end

return M
