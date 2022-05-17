" Lua langauge

augroup lua_settings_options
    autocmd! * <buffer>
    autocmd BufWritePre <buffer> %s/\s\+$//e
    autocmd Filetype lua setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
augroup end

