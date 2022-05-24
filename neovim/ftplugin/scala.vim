
if has('nvim-0.5')
  augroup scala_ft_local
    autocmd! * <buffer>
    au FileType scala,sbt lua vim.opt_global.shortmess:remove("F")
    au FileType scala,sbt nnoremap <Leader>m :lua require("telescope").extensions.metals.commands()<CR>
  augroup end
endif

