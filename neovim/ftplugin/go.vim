" Golang 

augroup go_settings_options
    autocmd!
    autocmd BufWritePre <buffer> %s/\s\+$//e
    autocmd BufNewFile,BufRead *.go setlocal noet ts=4 sw=4 sts=4
augroup end

