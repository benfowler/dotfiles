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
        toggle_colorcolumn = "<leader>C",
        toggle_wrap = "<leader>W",
        new_split = "<leader>-",
        new_vsplit = "<leader><bar>",
        new_terminal_quick = "<leader>tt",   -- subject to change
        new_terminal_here = "<leader>th",
        new_terminal_split = "<leader>tx",
        new_terminal_vsplit = "<leader>tv",
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
        Telescope_main = "<leader>TT",

        -- Telescope-specific mapping: help etc
        marks = "<leader>MM",
        registers = "<leader>RR",
        jumplist = "<leader>JJ",
        autocommands = "<leader>Ta",
        help_tags = "<leader>Th",
        man_pages = "<leader>Tm",
        keymaps = "<leader>Tk",
        highlights = "<leader>Ti",


        -- Search everywhere
        live_grep = "<leader>TA",    -- Telescope's slower alternative to fzf

        -- Git objects
        git_status = "<leader>gs",
        git_commits = "<leader>gc",
        git_bcommits = "<leader>gC",
        git_branches = "<leader>gb",
        git_stash = "<leader>gS",

        -- Files
        git_files = "<leader>fg",
        find_files = "<leader>ff",
        file_browser = "<leader>fb",
        oldfiles = "<leader>fo",

        spell_suggest = "z=",
    },

    fzf = {
        buffers = ";",
        recent_files = "<C-p>", -- quick file access
        ripgrep =  "<Leader>A", -- search everywhere (but fast)
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
    map("n", miscMap.new_split, ":split<CR>", opt)
    map("n", miscMap.new_vsplit, ":vsplit<CR>", opt)

    -- Fast terminals
    local shell = vim.env.SHELL
    map("n", miscMap.new_terminal_quick, string.format(":15sp term://%s<CR>", shell), opt)
    map("n", miscMap.new_terminal_here, ":terminal<CR>", opt)
    map("n", miscMap.new_terminal_split, string.format(":sp term://%s<CR>", shell), opt)
    map("n", miscMap.new_terminal_vsplit, string.format(":vsp term://%s<CR>", shell), opt)

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

    map("t", m.pane_left, "<C-\\><C-n>:TmuxNavigateLeft<CR>", opt)
    map("t", m.pane_down, "<C-\\><C-n>:TmuxNavigateDown<CR>", opt)
    map("t", m.pane_up, "<C-\\><C-n>:TmuxNavigateUp<CR>", opt)
    map("t", m.pane_right, "<C-\\><C-n>:TmuxNavigateRight<CR>", opt)

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
   -- stylua: ignore
	map( "n", m.Telescope_main, ":silent! Telescope builtin theme=get_dropdown previewer=false layout_config={'width':40,'height':0.5}<CR>", opt)

    -- Fast shortcuts to core Vim state
    map("n", m.marks, ":silent! Telescope marks<CR>", opt)
    map("n", m.registers, ":silent! Telescope registers<CR>", opt)
    map("n", m.jumplist, ":silent! Telescope jumplist<CR>", opt)
    map("n", m.help_tags, ":silent! Telescope help_tags<CR>", opt)
    map("n", m.man_pages, ":silent! Telescope man_pages<CR>", opt)
    map("n", m.keymaps, ":silent! Telescope keymaps<CR>", opt)
    map("n", m.highlights, ":silent! Telescope highlights<CR>", opt)
    map("n", m.autocommands, ":silent! Telescope autocommands<CR>", opt)


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

    map("n", m.spell_suggest, ":silent! Telescope spell_suggest<CR>", opt)
end

M.fzf = function()
    local m = user_map.fzf
    map("n", m.recent_files, ":silent! Files<CR>", opt)
    map("n", m.buffers, ":silent! Buffers<CR>", opt)
    map("n", m.ripgrep, ":silent! Rg<CR>", opt)
end

return M
