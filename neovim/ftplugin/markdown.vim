setlocal pumheight=7

setlocal colorcolumn=81
setlocal conceallevel=2
setlocal textwidth=80

" Spelling corrections from dict in omnicomplete by default
setlocal spell
setlocal complete+=k
setlocal dictionary+=/usr/share/dict/words

" Disable nvim-cmp
let b:cmp=0

