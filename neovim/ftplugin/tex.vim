" TeX editing

augroup tex_settings_options
    autocmd!
    autocmd BufWritePre <buffer> %s/\s\+$//e
augroup end

