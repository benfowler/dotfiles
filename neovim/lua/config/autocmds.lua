local function augroup(name)
  return vim.api.nvim_create_augroup("my_nvim_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup "checktime",
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd "checktime"
    end
  end,
})

-- Create directories as required when saving files
vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup "auto_create_dir",
    callback = function(event)
        local file = vim.loop.fs_realpath(event.match) or event.match

        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
        local backup = vim.fn.fnamemodify(file, ":p:~:h")
        backup = backup:gsub("[/\\]", "%%")
        vim.go.backupext = backup
    end,
})

-- Useful custom command to yank current file location
local yank_location_fn = function()
    local r, _ = unpack(vim.api.nvim_win_get_cursor(0))
    local deets = vim.fn.expand "%" .. ":" .. r
    print(deets)
    vim.fn.setreg("*", deets)
end

vim.api.nvim_create_user_command("YankLocation", yank_location_fn, {})

-- Restore cursor position
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    group = augroup "last_loc",
    pattern = { "*" },
    callback = function()
        vim.api.nvim_exec('silent! normal! g`"zv', false)
    end,
})

-- Delete trailing whitespace on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    command = [[%s/\s\+$//e]],
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup "yank_highlight",
    callback = function()
        vim.highlight.on_yank { timeout = 700 }
    end,
})

-- Show cursor line only in active window
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
    group = augroup "show_cl_only_in_active_win_on",
    callback = function()
        local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
        if ok and cl then
            vim.wo.cursorline = true
            vim.api.nvim_win_del_var(0, "auto-cursorline")
        end
    end,
})

vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
    group = augroup "show_cl_only_in_active_win_off",
    callback = function()
        local cl = vim.wo.cursorline
        if cl then
            vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
            vim.wo.cursorline = false
        end
    end,
})

-- Hide statusline for various filetypes
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "WinEnter", "CmdwinEnter", "TermEnter" }, {
    group = augroup "hide_statusline_for_win",
    callback = function()
        if vim.bo.ft == "NvimTree" then
            vim.go.laststatus = 0
        else
            vim.go.laststatus = 2
        end
    end,
})

-- Terminal customisations.

vim.api.nvim_create_autocmd("TermOpen", {
    group = augroup "term_open_opts",
    pattern = "term://*",
    command = "setlocal listchars= nonumber norelativenumber nocursorline nospell",
})

vim.api.nvim_create_autocmd("TermOpen", {
    group = augroup "term_open_ft",
    pattern = "term://*",
    command = "setfiletype terminal",
})

vim.api.nvim_create_autocmd("TermOpen", {
    group = augroup "term_open_insert",
    pattern = "term://*",
    command = "startinsert",
})

-- Close terminal buffer on prcess exit
vim.api.nvim_create_autocmd("TermClose", {
    group = augroup "term_close",
    pattern = vim.fn.expand "$SHELL" .. "\\|zsh",
    command = ":bd",
})

-- Set filetype for .env and .env.* files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup "env_filetype",
  pattern = { "*.env", ".env.*" },
  callback = function()
    vim.opt_local.filetype = "sh"
  end,
})

-- Detect AWS CloudFormation templates
vim.api.nvim_create_autocmd({ "BufRead" }, {
    group = augroup "detect_cfn",
    pattern = { "*.yaml" },
    callback = function()
        local header = vim.api.nvim_buf_get_lines(0, 0, 2, false)
        if header[1] == "---" and header[2] == "AWSTemplateFormatVersion: '2010-09-09'" then
            vim.bo.ft = "cloudformation"
            vim.bo.syntax = "yaml"
        end
    end,
})

