local M = {}

local winbar_file = function()
    return "%#WinBar#%= %m %f "
end

local exclude_filetype = {
    'help',
    'startify',
    'dashboard',
    'packer',
    'neogitstatus',
    'NvimTree',
    'Trouble',
    'alpha',
    'lir',
    'Outline',
    'spectre_panel',
    'toggleterm',
    'terminal',
    'qf',
}

local excludes = function()
    local ftype = vim.bo.filetype
    if ftype == nil or ftype == '' or vim.tbl_contains(exclude_filetype, ftype) then
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

    local status_ok, _ = pcall(vim.api.nvim_set_option_value, 'winbar', value, { scope = 'local' })
    if not status_ok then
        return
    end
end

function M.setup()
    vim.api.nvim_create_autocmd({ 'DirChanged', 'BufWinEnter', 'BufFilePost', 'InsertEnter', 'BufWritePost' }, {
        callback = function()
            M.show_winbar()
        end
    })
end

M.setup()

return M
