-- Key mappings

local M = {}

-- Global (non-plugin specific) mappings

-- c-l in INSERT mode, attempts to fix the last spelling error
-- TODO: port to Lua
vim.cmd([[ inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u ]])

-- Document keymapping groups in which-key.nvim
M.which_key_groups = {
  ["<leader>"] = {
    c = { name = "Commands" },
    g = { name = "Git" },
    l = {
      name = "LSP",
      w = {
        name = "Workspace",
      }
    },
    m = { name = "Markdown" },
    t = { name = "Telescope" },
    h = { name = "GitSigns" },
    u = { name = "UI" },
  }
}


-- Keybindings, hoisted from the options and plugins configuration. Expose and
-- modify keybindings here.  Make sure you don't use same keys twice.

M.misc = {
	mapleader = " ",
	toggle_listchars = "<leader>,",
	toggle_spellcheck = "<F6>",
	toggle_colorcolumn = "<leader>c",
	cycle_conceal = "<leader>C",
	new_split = "<leader>-",
	new_vsplit = "<leader><bar>",
	new_terminal_quick = "<leader>TT",
	new_terminal_here = "<leader>Th",
	new_terminal_split = "<leader>Tx",
	new_terminal_vsplit = "<leader>Tv",
	write_file = "<M-s>",
	write_file_2 = "<leader>W",
}

M.notify = {
  delete_all = "<leader>un",
}

M.zenmode = {
	toggle_zenmode = "<leader>z",
}

M.hop = {
  easymotion_word_ac = "<leader>w",
  easymotion_word_bc = "<leader>b",
  easymotion_line_ac = "<leader>j",
  easymotion_line_bc = "<leader>k",
  sneak_char_ac = "s",
  sneak_char_bc = "S",
}

M.easy_align = {
  easy_align = "ga",
}

M.comment_nvim = {
	comment_toggle = "<leader>/",
}

M.nvimtree = {
	treetoggle = "<C-n>", -- file manager
	treefocus = "<leader>F", -- file manager
}

M.lsp = {
  lspinfo = "<leader>lI",
}

-- Telescope-specific mapping: help etc
M.telescope = {
	telescope = "<leader>tt",
	files = "<leader>tf",
	buffers = "<leader>tb",
	marks = "<leader>tM",
	registers = "<leader>tr",
	jumplist = "<leader>tj",
	autocommands = "<leader>ta",
	help_tags = "<leader>th",
	man_pages = "<leader>tm",
	keymaps = "<leader>tk",
	highlights = "<leader>ti",

	-- LSP
	lsp_diagnostics = "<leader>lwd",
	lsp_diagnostics_doc = "<leader>ldd",

	lsp_symbols = "<leader>lws",
	lsp_symbols_doc = "<leader>lds",

	lsp_definitions = "<leader>ld",
	lsp_implementations = "<leader>li",
	lsp_references = "<leader>lr",
	lsp_type_definitions = "<leader>lt",

	-- Git objects
	git_commits = "<leader>gc",
	git_bcommits = "<leader>gC",
	git_branches = "<leader>gb",
	git_stash = "<leader>gs",
	git_files = "<leader>gf",

	-- LuaSnip
	select_snippet = "<leader>s",

  markdown_headings = "<leader>mh",

	spell_suggest = "z=",
}

M.lazygit = {
	lazygit = "<leader>G",
}

M.trouble = {
	trouble = "<leader>d",
}

M.fzf = {
	buffers = ";",
	files = "<C-p>",        -- quick file access
	gfiles = "<M-p>",       -- quick file access (Git)
	history = "<M-o>",      -- quick file access (history)
	ripgrep = "<Leader>r",  -- search everywhere (but fast)
}

M.fugitive = {
	Git = "<leader>gg",
	diffget_2 = "<leader>gh",
	diffget_3 = "<leader>gl",
	git_blame = "<leader>ga",
}

M.gitsigns = {
  select_hunk_text_object = "ih",
	next_hunk = "]h",
	prev_hunk = "[h",
	stage_hunk = "<leader>hs",
	undo_stage_hunk = "<leader>hu",
	reset_hunk = "<leader>hr",
	preview_hunk = "<leader>hp",
	blame_line = "<leader>hb",
	quickfix = "<leader>hq",
	diffthis = "<leader>hd",

	stage_buffer = "<leader>hS",
	reset_buffer = "<leader>hR",
	toggle_current_line_blame = "<leader>hB",
	diffthis2 = "<leader>hD",
	toggle_deleted = "<leader>td",
}

-- Navigate across vim splits and TMUX panes
M.tmuxnavigator = {
	pane_left = "<M-h>",
	pane_down = "<M-j>",
	pane_up = "<M-k>",
	pane_right = "<M-l>",
}

return M
