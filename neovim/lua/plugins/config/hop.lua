-- hop.nvim
require("hop").setup {}

-- normal mode (easymotion-like)
vim.api.nvim_set_keymap("n", "<Leader>b", "<cmd>HopWordBC<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>w", "<cmd>HopWordAC<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>j", "<cmd>HopLineAC<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>k", "<cmd>HopLineBC<CR>", { noremap = true })

-- visual mode (easymotion-like)
vim.api.nvim_set_keymap("v", "<Leader>w", "<cmd>HopWordAC<CR>", { noremap = true })
vim.api.nvim_set_keymap("v", "<Leader>b", "<cmd>HopWordBC<CR>", { noremap = true })
vim.api.nvim_set_keymap("v", "<Leader>j", "<cmd>HopLineAC<CR>", { noremap = true })
vim.api.nvim_set_keymap("v", "<Leader>k", "<cmd>HopLineBC<CR>", { noremap = true })

-- normal mode (sneak-like)
vim.api.nvim_set_keymap("n", "s", "<cmd>HopChar2AC<CR>", { noremap = false })
vim.api.nvim_set_keymap("n", "S", "<cmd>HopChar2BC<CR>", { noremap = false })

-- visual mode (sneak-like)
vim.api.nvim_set_keymap("v", "s", "<cmd>HopChar2AC<CR>", { noremap = false })
vim.api.nvim_set_keymap("v", "S", "<cmd>HopChar2BC<CR>", { noremap = false })
