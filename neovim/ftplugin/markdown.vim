" Markdown-specific configuration

augroup filetype_markdown
    autocmd!

    autocmd BufWritePre <buffer> %s/\s\+$//e

    autocmd filetype markdown setlocal pumheight=7

    autocmd filetype markdown setlocal conceallevel=2
    autocmd filetype markdown setlocal textwidth=80

    " Spelling corrections from dict in omnicomplete by default
    autocmd filetype markdown setlocal complete+=k
    autocmd filetype markdown setlocal dictionary+=/usr/share/dict/words

    " More-aggressive highlighting (otherwise, chokes on line files)
    syntax sync minlines=1000

    "
    " TODO: move to mappings and migrate once autogroup Lua bindings exist
    "

    autocmd filetype markdown nnoremap <leader>mm :silent !open -a Marked\ 2.app '%:p'<cr>
    autocmd filetype markdown nnoremap <leader>mh :Telescope heading theme=get_dropdown<cr>
augroup END
