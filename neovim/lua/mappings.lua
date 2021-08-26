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
      toggle_number = "<leader>N",
      toggle_wrap = "<leader>W",
      new_split = "<leader>-",
      new_vsplit = "<leader><bar>",
      write_file = "<leader>w",
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
      treetoggle = "<leader>n", -- file manager
      treefocus = "<leader>F", -- file manager
   },
   neoformat = {
      format = "<leader>fm",
   },
   telescope = {
      telescope_main = "<leader>tt",

      -- Search everywhere
      live_grep = "<leader>A",

      -- Git objects
      git_status = "<leader>gs",
      git_commits = "<leader>gc",
      git_bcommits = "<leader>gC",
      git_branches = "<leader>gb",
      git_stash = "<leader>gS",

      -- Files
      git_files= "<leader>fg",
      find_files = "<leader>ff",
      file_browser = "<leader>fb",
      oldfiles = "<leader>fo",
      oldfiles_quick = "<C-p>",     -- quick file access (no preview)

      -- Buffers
      buffers = "<leader>bb",
      buffers_quick = ";",          -- quick switch (no preview)

      -- Help (and helpful things)
      help_tags = "<leader>hh",
      keymaps= "<leader>hk",
      highlights = "<leader>hi",

      spell_suggest = "z=",
   },
   fugitive = {
      Git = "<leader>gg",
      diffget_2 = "<leader>gh",
      diffget_3 = "<leader>gl",
      git_blame = "<leader>ga",
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
   ultisnips = {
      select_snippet = "<leader>s",
      edit_snippets = "<leader>S",
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
local function map(mode, lhs, rhs, extra_opts)
   local options = { noremap = true, silent = true }
   if extra_opts then
      options = vim.tbl_extend("force", options, extra_opts)
   end
   vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end


vim.g.mapleader = miscMap.mapleader


-- (These mappings will be called during initialization)
M.misc = function()

   -- Fast write-file shortcut
   map("n", miscMap.write_file, ":update<CR>", opt)

   -- Setting toggles
   map("n", miscMap.toggle_spellcheck, ":set spell! <CR>", opt)
   map("i", miscMap.toggle_spellcheck, "<C-o>:set spell! <CR>", opt)

   map("n", miscMap.toggle_wrap, ":set invwrap <CR>", opt)
   map("n", miscMap.toggle_number, ":set invnumber<CR>:set invrelativenumber<CR>:set invcursorline<CR>", opt)
   map("n", miscMap.toggle_listchars, ":set invlist <CR>", opt)

   -- Indent: leave selection intact
   map("v", ">", ">gv", opt)
   map("v", "<", "<gv", opt)

   -- Fast splits
   map("n", miscMap.new_split, ":below split<cr>", opt)
   map("n", miscMap.new_vsplit, ":below vsplit<cr>", opt)

   -- Fast quickfix and location list navigation
   map("n", "[l", ":lprev<CR>zv", opt)
   map("n", "]l", ":lnext<CR>zv", opt)
   map("n", "[q", ":cprev<CR>zv", opt)
   map("n", "]q", ":cnext<CR>zv", opt)

   -- C-j and C-k to navigate in popup ('pum') menu and wildmenu
   cmd [[ inoremap <expr><C-j> pumvisible() ? "\<C-n>" : "\<C-j>" ]]
   cmd [[ inoremap <expr><C-k> pumvisible() ? "\<C-p>" : "\<C-h>" ]]
   cmd [[ cnoremap <expr><C-j> wildmenumode() ? "\<C-n>" : "\<C-j>" ]]
   cmd [[ cnoremap <expr><C-k> wildmenumode() ? "\<C-p>" : "\<C-h>" ]]


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
   local m = user_map.nvimtree

   map("n", m.treetoggle, ":NvimTreeToggle<CR>", opt)
   map("n", m.treefocus, ":NvimTreeFocus<CR>", opt)
end

M.truezen = function()
   local m = user_map.truezen

   map("n", m.ataraxisMode, ":TZAtaraxis<CR>", opt)
   map("n", m.minimalisticmode, ":TZMinimalist<CR>", opt)
   map("n", m.focusmode, ":TZFocus<CR>", opt)
end

M.telescope = function()
   local m = user_map.telescope

   -- All available pickers
   map("n", m.telescope_main, ":silent! Telescope builtin theme=get_dropdown previewer=false layout_config={'width':40,'height':0.5}<CR>", opt)

   -- Search everywhere
   map("n", m.live_grep, ":silent! Telescope live_grep<CR>", opt)

   -- Git objects
   map("n", m.git_status, ":silent! Telescope git_status<CR>", opt)
   map("n", m.git_commits, ":silent! Telescope git_commits<CR>", opt)
   map("n", m.git_bcommits, ":silent! Telescope git_bcommits<CR>", opt)
   map("n", m.git_branches, ":silent! Telescope git_branches<CR>", opt)
   map("n", m.git_stash, ":silent! Telescope git_stash<CR>", opt)
   map("n", m.git_files, ":silent! Telescope git_files<CR>", opt)

   -- Files
   map("n", m.find_files, ":silent! Telescope find_files <CR>", opt)
   map("n", m.file_browser, ":silent! Telescope file_browser<CR>", opt)
   map("n", m.oldfiles, ":silent! Telescope oldfiles<CR>", opt)
   map("n", m.oldfiles_quick, ":Telescope oldfiles theme=get_dropdown previewer=false layout_config={'height':8,'width':0.7}<CR>", opt)

   -- Buffers
   map("n", m.buffers, ":silent! Telescope buffers<CR>", opt)
   map("n", m.buffers_quick, ":Telescope buffers theme=get_dropdown previewer=false layout_config={'height':8,'width':.5}<CR>", opt)

   -- Help (and helpful things)
   map("n", m.help_tags, ":silent! Telescope help_tags<CR>", opt)
   map("n", m.keymaps, ":silent! Telescope keymaps<CR>", opt)
   map("n", m.highlights, ":silent! Telescope highlights<CR>", opt)

   map("n", m.spell_suggest, ":silent! Telescope spell_suggest<CR>", opt)
end

M.ultisnips = function()
   local m = user_map.ultisnips

   map("n", m.select_snippet, ":silent! Telescope ultisnips theme=get_dropdown layout_config={'height':0.5}<CR>", opt)
   map("n", m.edit_snippets, ":UltiSnipsEdit<CR>", opt)
end

return M

