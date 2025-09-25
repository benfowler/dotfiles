-- Define commmands to toggle nvim-cmp automatic completion popups

local function enable_cmp_autocomplete()
    local present, cmp = pcall(require, "cmp")
    if not present then return end;

    cmp.setup({ completion = { autocomplete = { cmp.TriggerEvent.TextChanged } }})
    vim.notify('Autocomplete enabled', vim.log.levels.INFO, { title = "nvim-cmp" })
end

local function disable_cmp_autocomplete()
    local present, cmp = pcall(require, "cmp")
    if not present then return end

    cmp.setup({ completion = { autocomplete = false }})
    vim.notify('Autocomplete disabled', vim.log.levels.INFO, { title = "nvim-cmp" })
end

local function toggle_cmp_autocomplete()
    local present, cmp = pcall(require, "cmp")
    if not present then return end

    local current_setting = cmp.get_config().completion.autocomplete
    if current_setting and #current_setting > 0 then
        disable_cmp_autocomplete()
    else
        enable_cmp_autocomplete()
    end
end

vim.api.nvim_create_user_command('NvimCmpEnable', enable_cmp_autocomplete, {})
vim.api.nvim_create_user_command('NvimCmpDisable', disable_cmp_autocomplete, {})
vim.api.nvim_create_user_command('NvimCmpToggle', toggle_cmp_autocomplete, {})

