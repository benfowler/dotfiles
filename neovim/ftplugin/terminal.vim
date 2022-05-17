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

