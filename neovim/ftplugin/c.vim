" C language

augroup c_settings_options
    autocmd! * <buffer>
    autocmd BufWritePre <buffer> %s/\s\+$//e
    autocmd BufNewFile,BufRead *.c setlocal noet ts=2 sw=2 sts=2
augroup end

