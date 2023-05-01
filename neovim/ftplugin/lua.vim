" Lua langauge

augroup lua_settings_options
    autocmd! * <buffer>
    autocmd BufWritePre <buffer> %s/\s\+$//e
    autocmd Filetype lua setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
augroup end

