local cmd = vim.cmd

local M = {}
local opt = {}

--
-- Keybindings, hoisted from the options and plugins configuration.
-- Expose and modify keybindings here.
--

-- Global mappings by plugin, then "misc" for everything else.  
-- Make sure you dont use same keys twice.

vim.g.mapleader = " "

M.user_map = {
   truezen = {
      ataraxisMode = "<leader>zz",
      minimalisticmode = "<leader>zm",
      focusmode = "<leader>zf",
   },
   comment_nvim = {
      comment_toggle = "<leader>/",
   },
   nvimtree = {
      treetoggle = "<C-n>", -- file manager
   },
   neoformat = {
      format = "<leader>fm",
   },
   dashboard = {
      open = "<leader>db",
      newfile = "<leader>fn",
      bookmarks = "<leader>bm",
      sessionload = "<leader>l",
      sessionsave = "<leader>s",
   },
   telescope = {
      live_grep = "<leader>fw",
      git_status = "<leader>gt",
      git_commits = "<leader>cm",
      find_files = "<leader>ff",
      buffers = "<leader>fb",
      help_tags = "<leader>fh",
      oldfiles = "<leader>fo",
      themes = "<leader>th",
   },
   fugitive = {
      Git = "<leader>gs",
      diffget_2 = "<leader>gh",
      diffget_3 = "<leader>gl",
      git_blame = "<leader>gb",
   },
   gitsigns = {
      next_hunk = "]h",
      prev_hunk = "[h",
      stage_hunk = "<leader>hs",
      undo_stage_hunk = "<leader>hu",
      reset_hunk = "<leader>hr",
      preview_hunk = "<leader>hp",
      blame_line = "<leader>hb",
   },
   terms = { -- below are NvChad mappings, not plugin mappings
      esc_termmode = "jk",
      esc_hide_termmode = "JK",
      pick_term = "<leader>W", -- note: this is a telescope extension
      new_wind = "<leader>w",
      new_vert = "<leader>v",
      new_hori = "<leader>h",
   }, -- navigation in insert mode
   insert_nav = {
      forward = "<C-l>",
      backward = "<C-h>",
      top_of_line = "<C-a>",
      end_of_line = "<C-e>",
      prev_line = "<C-j>",
      next_line = "<C-k>",
   },
   -- non plugin
   misc = {
      esc_Termmode = "jk", -- get out of terminal mode
      close_buffer = "<S-x>", -- close current focused buffer
      copywhole_file = "<C-a>",
      toggle_linenr = "<leader>n", -- show or hide line number
      theme_toggle = "<leader>x",
      update_nvchad = "<leader>uu",
   },
}


-- These mappings will only be called during initialization
M.misc = function()
   -- Packer commands, because we are not loading it at startup
   cmd "silent! command PackerCompile lua require 'pluginList' require('packer').compile()"
   cmd "silent! command PackerInstall lua require 'pluginList' require('packer').install()"
   cmd "silent! command PackerStatus lua require 'pluginList' require('packer').status()"
   cmd "silent! command PackerSync lua require 'pluginList' require('packer').sync()"
   cmd "silent! command PackerUpdate lua require 'pluginList' require('packer').update()"
end


-- Make keybinding with optional options
local function map(mode, lhs, rhs, opts)
   local options = { noremap = true, silent = true }
   if opts then
      options = vim.tbl_extend("force", options, opts)
   end
   vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end


--
-- Plugin mappings
--

-- (convenience locals)
local user_map = M.user_map
local miscMap = M.user_map.misc


M.fugitive = function()
   local m = user_map.fugitive

   map("n", m.Git, ":Git<CR>", opt)
   map("n", m.diffget_2, ":diffget //2<CR>", opt)
   map("n", m.diffget_3, ":diffget //3<CR>", opt)
   map("n", m.git_blame, ":Git blame<CR>", opt)
end

M.nvimtree = function()
   local m = user_map.nvimtree.treetoggle

   map("n", m, ":NvimTreeToggle<CR>", opt)
end


return M

