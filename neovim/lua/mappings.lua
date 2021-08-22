local cmd = vim.cmd

local M = {}
local opt = {}

-- Keybindings, hoisted from the options and plugins configuration. Expose and 
-- modify keybindings here.  Make sure you don't use same keys twice.
M.user_map = {
   misc = {
      mapleader = " ",
      toggle_listchars = "<leader>,",
      toggle_spellcheck = "<F6>",
      toggle_number = "<leader>n",
   },
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
      buffers_quick = ";",          -- quick switch (no preview)
      help_tags = "<leader>fh",
      oldfiles = "<leader>fo",
      oldfiles_quick = "<C-p>",     -- quick file access (no preview)
      spell_suggest = "z=",
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
   vim_tmux_navigator = {
      pane_up = "<M-Up>",
      pane_down = "<M-Down>",
      pane_left = "<M-Left>",
      pane_right = "<M-Right>",
   },
}


-- (convenience locals)
local user_map = M.user_map
local miscMap = M.user_map.misc


-- Make keybinding with optional options
local function map(mode, lhs, rhs, opts)
   local options = { noremap = true, silent = true }
   if opts then
      options = vim.tbl_extend("force", options, opts)
   end
   vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end


vim.g.mapleader = miscMap.mapleader


-- (These mappings will be called during initialization)
M.misc = function()

   -- Toggle hidden characters
   map("n", miscMap.toggle_listchars, ":set invlist <cr>", opts)

   -- Toggle line numbers (hybrid mode)
   map("n", miscMap.toggle_number, ":set invnumber<cr>:set invrelativenumber<cr>", opts)
   
   -- Toggle spellcheck
   map("n", miscMap.toggle_spellcheck, ":set spell! <cr>", opts)
   map("i", miscMap.toggle_spellcheck, "<C-o>:set spell! <cr>", opts)

   -- Packer commands, because we are not loading it at startup
   cmd "silent! command PackerCompile lua require 'pluginList' require('packer').compile()"
   cmd "silent! command PackerInstall lua require 'pluginList' require('packer').install()"
   cmd "silent! command PackerStatus lua require 'pluginList' require('packer').status()"
   cmd "silent! command PackerSync lua require 'pluginList' require('packer').sync()"
   cmd "silent! command PackerUpdate lua require 'pluginList' require('packer').update()"
end


--
-- Plugin mappings
--

M.comment_nvim = function()
   local m = user_map.comment_nvim.comment_toggle

   map("n", m, ":CommentToggle<CR>", opt)
   map("v", m, ":CommentToggle<CR>", opt)
end

M.easy_align = function() 
   -- TODO: how to do this idiomatically in Lua?
   -- (This needs to be done this way, otherwise things like "gavip," won't work)
   cmd "nmap ga <Plug>(EasyAlign)"
   cmd "xmap ga <Plug>(EasyAlign)"
end

M.fugitive = function()
   local m = user_map.fugitive

   map("n", m.Git, ":Git<CR>", opt)
   map("n", m.diffget_2, ":diffget //2<CR>", opt)
   map("n", m.diffget_3, ":diffget //3<CR>", opt)
   map("n", m.git_blame, ":Git blame<CR>", opt)
end

M.vim_tmux_navigator = function() 
   local m = user_map.vim_tmux_navigator

   map("n", m.pane_left, ":TmuxNavigateLeft<CR>", opt)
   map("n", m.pane_down, ":TmuxNavigateDown<CR>", opt)
   map("n", m.pane_up, ":TmuxNavigateUp<CR>", opt)
   map("n", m.pane_right, ":TmuxNavigateRight<CR>", opt)

   vim.g.tmux_navigator_no_mappings = 1
end

M.nvimtree = function()
   local m = user_map.nvimtree.treetoggle

   map("n", m, ":NvimTreeToggle<CR>", opt)
end

M.truezen = function()
   local m = user_map.truezen

   map("n", m.ataraxisMode, ":TZAtaraxis<CR>", opt)
   map("n", m.minimalisticmode, ":TZMinimalist<CR>", opt)
   map("n", m.focusmode, ":TZFocus<CR>", opt)
end

M.telescope = function()
   local m = user_map.telescope

   map("n", m.live_grep, ":Telescope live_grep<CR>", opt)
   map("n", m.git_status, ":Telescope git_status <CR>", opt)
   map("n", m.git_commits, ":Telescope git_commits <CR>", opt)
   map("n", m.find_files, ":Telescope find_files <CR>", opt)
   map("n", m.buffers, ":Telescope buffers<CR>", opt)
   map("n", m.buffers_quick, ":Telescope buffers previewer=false<CR>", opt)
   map("n", m.help_tags, ":Telescope help_tags<CR>", opt)
   map("n", m.oldfiles, ":Telescope oldfiles<CR>", opt)
   map("n", m.oldfiles_quick, ":Telescope oldfiles theme=get_dropdown previewer=false <CR>", opt)
   map("n", m.spell_suggest, ":Telescope spell_suggest<CR>", opt)
end

return M

