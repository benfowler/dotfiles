if has('nvim-0.5')
  augroup lsp
    au!
    au FileType scala,sbt lua require("metals").initialize_or_attach({})
    au FileType scala,sbt nnoremap <Leader>m :silent! lua require("telescope").extensions.metals.commands()<CR>
  augroup end
endif

