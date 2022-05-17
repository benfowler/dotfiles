" C language

augroup c_settings_options
    autocmd! * <buffer>
    autocmd BufWritePre <buffer> %s/\s\+$//e
augroup end

