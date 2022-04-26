" YAML editing

augroup yaml_settings_options
    autocmd!
    autocmd BufWritePre <buffer> %s/\s\+$//e
augroup end

