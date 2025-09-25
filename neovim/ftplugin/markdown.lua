
-- Pmenu max height
vim.opt.pumheight = 7

vim.opt.colorcolumn = '81'
vim.opt.conceallevel = 2
vim.opt.textwidth = 80

-- Spelling corrections from dict in omnicomplete by default
vim.opt.complete:append("k")
vim.opt.dictionary:append("/usr/share/dict/words")

vim.opt.spell = true
