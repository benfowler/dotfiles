local M = {}

local icons = require("util").diagnostic_icons.filled

local lsp_diags_config = {
    { highlight = "ErrorWinbarDiagIndic", icon = icons.error },
    { highlight = "WarnWinbarDiagIndic", icon = icons.warn },
    { highlight = "InfoWinbarDiagIndic", icon = icons.info },
    { highlight = "HintWinbarDiagIndic", icon = icons.hint },
    { highlight = "OkWinbarDiagIndic", icon = "󰓛" },
}

local winbar_file = function()
    local worst = nil
    local worst_str = ""

    if #vim.lsp.get_clients() ~= 0 then
        local bufnr = vim.fn.bufnr()
        local diagnostics = vim.diagnostic.get(bufnr)
        worst = 5 -- sentinel value for 'ok'
        for _, diagnostic in ipairs(diagnostics) do
            local severity = diagnostic.severity
            if severity < worst then
                worst = severity
            end
        end

        worst_str = "%#" .. lsp_diags_config[worst].highlight .. "#" .. lsp_diags_config[worst].icon .. " "
    end

    return "%#WinBar#%= %m %f " .. worst_str
end

M.show_winbar = function()
    if vim.bo.filetype ~= "" and vim.bo.buftype == "" then
        local value = winbar_file()
        local status_ok, _ = pcall(vim.api.nvim_set_option_value, "winbar", value, { scope = "local" })
        if not status_ok then
            return
        end
    end
end

function M.setup()
    vim.api.nvim_create_autocmd({
        "BufAdd",
        "BufFilePost",
        "BufWinEnter",
        "BufWritePost",
        "DiagnosticChanged",
        "DirChanged",
        "InsertEnter",
        "WinEnter",
    }, {
        callback = function()
            M.show_winbar()
        end,
    })
end

M.setup()

return M
