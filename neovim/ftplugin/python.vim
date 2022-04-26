" Python language

augroup python_settings_options
    autocmd!
    autocmd BufWritePre <buffer> %s/\s\+$//e
    autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
augroup end

