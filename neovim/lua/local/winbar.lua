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

local exclude_filetype = {
    "help",
    "startify",
    "dashboard",
    "packer",
    "neogitstatus",
    "NvimTree",
    "Trouble",
    "alpha",
    "lir",
    "Outline",
    "spectre_panel",
    "TelescopePrompt",
    "toggleterm",
    "terminal",
    "qf",
}

local exclude_buftype = {
    "terminal",
}

local excludes = function()
    local ftype = vim.bo.filetype
    local btype = vim.bo.buftype
    if
        vim.tbl_contains(exclude_buftype, btype)
        or ftype == nil
        or ftype == ""
        or vim.tbl_contains(exclude_filetype, ftype)
    then
        vim.opt_local.winbar = nil
        return true
    end

    return false
end

M.show_winbar = function()
    if excludes() then
        return
    end

    local value = winbar_file()

    local status_ok, _ = pcall(vim.api.nvim_set_option_value, "winbar", value, { scope = "local" })
    if not status_ok then
        return
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
