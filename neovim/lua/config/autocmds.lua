-- Show cursor line only in active window
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
    callback = function()
        local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
        if ok and cl then
            vim.wo.cursorline = true
            vim.api.nvim_win_del_var(0, "auto-cursorline")
        end
    end,
})

vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
    callback = function()
        local cl = vim.wo.cursorline
        if cl then
            vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
            vim.wo.cursorline = false
        end
    end,
})

-- Create directories when needed, when saving a file
vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
    callback = function(event)
        local file = vim.loop.fs_realpath(event.match) or event.match

        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
        local backup = vim.fn.fnamemodify(file, ":p:~:h")
        backup = backup:gsub("[/\\]", "%%")
        vim.go.backupext = backup
    end,
})

-- Fix conceallevel for json & help files
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "json", "jsonc" },
    callback = function()
        vim.wo.spell = false
        vim.wo.conceallevel = 0
    end,
})


 -- Autogroup for autocommands
 -- stylua: ignore
 -- TODO: port everything below to Lua
 vim.cmd [[
    augroup global_custom_autocmds
    autocmd!

        " Useful custom command to yank current location
        command! YankLocation let @ = join([expand('%'),  line(".")], ':') 

        " Open a file from its last left off position
        " See :help last-position-jump
        function! JumpToLastEditOnOpen()
        if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
            exe "normal! g`\""
        endif
        endfunction

        autocmd BufReadPost * call JumpToLastEditOnOpen()


        " Tweak filetypes of certain kinds of files
        autocmd BufRead * if getbufline(bufnr('%'), 1, 2) == ['---', 'AWSTemplateFormatVersion: ''2010-09-09'''] | setlocal ft=cloudformation | endif

        " Don't show status line on certain windows
        let g:hidden_statusline = [ 'NvimTree', ]

        function! HideStatusbarOnOpen()
        if index(g:hidden_statusline, &ft) >= 0
            set laststatus=0
        else
            set laststatus=2
        endif
        endfunction

        autocmd BufEnter,BufWinEnter,WinEnter,CmdwinEnter,TermEnter * nested call HideStatusbarOnOpen()

    augroup END

    " 'terminal' file type
    " (NeoVim's terminal defaults are bad; fix them)

    augroup term_settings_options
        autocmd! * <buffer>

        " Don't show any numbers inside terminals
        autocmd TermOpen term://* setlocal nonumber norelativenumber
        autocmd TermOpen term://* setfiletype terminal

        " Open new terminals in insert mode
        autocmd TermOpen term://* startinsert

        " If terminal is running default shell, I don't care about the exit status
        autocmd TermClose $SHELL\|zsh :bd
    augroup end

 ]]

