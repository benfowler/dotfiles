" Markdown-specific configuration

augroup filetype_markdown
    autocmd! * <buffer>

    autocmd BufWritePre <buffer> %s/\s\+$//e

    autocmd filetype markdown setlocal pumheight=7

    autocmd filetype markdown setlocal colorcolumn=81
    autocmd filetype markdown setlocal conceallevel=2
    autocmd filetype markdown setlocal textwidth=80

    " Spelling corrections from dict in omnicomplete by default
    "autocmd filetype markdown setlocal spell
    autocmd filetype markdown setlocal complete+=k
    autocmd filetype markdown setlocal dictionary+=/usr/share/dict/words

    " More-aggressive highlighting (otherwise, chokes on line files)
    syntax sync minlines=1500

augroup END
