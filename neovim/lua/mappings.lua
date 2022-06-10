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
        toggle_colorcolumn = "<leader>c",
        toggle_wrap = "<leader>W",
        cycle_conceal = "<leader>C",
        new_split = "<leader>-",
        new_vsplit = "<leader><bar>",
        new_terminal_quick = "<leader>TT",
        new_terminal_here = "<leader>Th",
        new_terminal_split = "<leader>Tx",
        new_terminal_vsplit = "<leader>Tv",
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
        treetoggle = "<C-n>", -- file manager
        treefocus = "<leader>F", -- file manager
    },

    telescope = {
        -- Telescope-specific mapping: help etc
        telescope_ = "<leader>tt",
        buffers_ = "<leader>tb",
        marks = "<leader>tM",
        registers = "<leader>tr",
        jumplist = "<leader>tj",
        autocommands = "<leader>ta",
        help_tags = "<leader>th",
        man_pages = "<leader>tm",
        keymaps = "<leader>tk",
        highlights = "<leader>ti",

        -- LSP
        lsp_diagnostics = "<leader>dd",
        lsp_diagnostics_doc = "<leader>DD",

        lsp_symbols = "<leader>LL",
        lsp_symbols_doc = "<leader>ll",

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

        -- Lazygit
        lazygit = "<leader>G",

        -- LuaSnip
        select_snippet = "<leader>s",

        spell_suggest = "z=",
    },

    trouble = {
        trouble = "<leader>j",
    },

    fzf = {
        buffers = ";",
        windows = "<leader>;",
        fzf_files = "<C-p>", -- quick file access
        fzf_history = "<M-p>", -- quick file access (history)
        fzf_gfiles = "<M-g>", -- quick file access (Git)
        ripgrep = "<Leader>r", -- search everywhere (but fast)
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
        pane_left = "<M-h>",
        pane_down = "<M-j>",
        pane_up = "<M-k>",
        pane_right = "<M-l>",
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

local function map_buf(bufnr, mode, lhs, rhs, extra_opts)
    local options = { noremap = true, silent = true }
    if extra_opts then
        options = vim.tbl_extend("force", options, extra_opts)
    end
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, options)
end

vim.g.mapleader = miscMap.mapleader

-- (These mappings will be called during initialization)
M.misc = function()
    -- Fast write-file shortcut
    map("n", miscMap.write_file, ":update<CR>", opt)

    -- Setting toggles
    map("n", miscMap.toggle_listchars, ":set invlist <CR>", opt)
    map("n", miscMap.toggle_spellcheck, ":set spell! <CR>", opt)
    map("i", miscMap.toggle_spellcheck, "<C-o>:set spell! <CR>", opt)
    map("n", miscMap.toggle_number, ":set invnumber<CR>:set invrelativenumber<CR>:set invcursorline<CR>", opt)
    map(
        "n",
        miscMap.toggle_colorcolumn,
        ":silent! if &colorcolumn==81 | let &colorcolumn = 121 | elseif &colorcolumn==121 | let &colorcolumn='' | else | let &colorcolumn=81 | endif<CR>",
        opt
    )
    map("n", miscMap.toggle_wrap, ":set invwrap <CR>", opt)
    map(
        "n",
        miscMap.cycle_conceal,
        ":silent! if &conceallevel==0 | let &conceallevel= 1 | elseif &conceallevel==1 | let &conceallevel=2 | else | let &conceallevel=0 | endif<CR>",
        opt
    )

    -- Indent: leave selection intact
    map("v", ">", ">gv", opt)
    map("v", "<", "<gv", opt)

    -- Quick-select last paste
    vim.cmd [[ nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]' ]]

    -- Fast splits
    map("n", miscMap.new_split, ":split<CR>", opt)
    map("n", miscMap.new_vsplit, ":vsplit<CR>", opt)

    -- Fast terminals
    local shell = vim.env.SHELL
    map("n", miscMap.new_terminal_quick, string.format(":15sp term://%s<CR>", shell), opt)
    map("n", miscMap.new_terminal_here, ":terminal<CR>", opt)
    map("n", miscMap.new_terminal_split, string.format(":sp term://%s<CR>", shell), opt)
    map("n", miscMap.new_terminal_vsplit, string.format(":vsp term://%s<CR>", shell), opt)

    -- Fast quickfix and location list navigation.  Centre editing line when navigating.
    map("n", "[l", ":lprev<CR>", opt)
    map("n", "]l", ":lnext<CR>", opt)
    map("n", "[q", ":cprev<CR>", opt)
    map("n", "]q", ":cnext<CR>", opt)

    -- Change doesn't overwrite the unnamed register (clipboard for me).
    -- I can change/paste, and not lose the clipboard contents I'm about to paste.
    map("n", "c", '"_c', opt)
    map("n", "C", '"_C', opt) -- "_ is the blackhole register


    -----------------------------------------------------------------------
    -- Lazy-loaded plugins still require mappings and commands,
    -- for when Packer needs to lazy-load off them.

    M.telescope()
    M.fzf()

    -- Packer commands, because we are not loading it at startup
    vim.api.nvim_create_user_command('PackerCompile', function() require 'plugins.init' require('packer').compile() end, {})
    vim.api.nvim_create_user_command('PackerInstall', function() require 'plugins.init' require('packer').install() end, {})
    vim.api.nvim_create_user_command('PackerStatus', function() require 'plugins.init' require('packer').status() end, {})
    vim.api.nvim_create_user_command('PackerSync', function() require 'plugins.init' require('packer').sync() end, {})
    vim.api.nvim_create_user_command('PackerUpdate', function() require 'plugins.init' require('packer').update() end, {})

    vim.api.nvim_create_user_command('PC', 'PackerCompile', {})
    vim.api.nvim_create_user_command('PS', 'PackerStatus', {})
    vim.api.nvim_create_user_command('PU', 'PackerSync', {})
end

--
-- LSP bindings (dynamically, by buffer)
--

M.lsp = function(bufnr, _)
    local opts = { noremap = true, silent = true }

    map_buf(bufnr, "n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    map_buf(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
    map_buf(bufnr, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    map_buf(bufnr, "n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>", opts)
    map_buf(bufnr, "n", "gk", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    map_buf(bufnr, "n", "gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    map_buf(bufnr, "n", "gt", "<Cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    map_buf(bufnr, "n", "gI", "<Cmd>lua vim.lsp.buf.incoming_calls()<CR>", opts)
    map_buf(bufnr, "n", "gO", " <Cmd>lua vim.lsp.buf.outgoing_calls()<CR>", opts)
    map_buf(bufnr, "n", "<Leader>gw", "<Cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
    map_buf(bufnr, "n", "<Leader>gW", "<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>", opts)
    map_buf(bufnr, "n", "<Leader>a", "<Cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    map_buf(bufnr, "n", "<Leader>A", "<Cmd>lua vim.lsp.codelens.run()<CR>", opts)
    map_buf(bufnr, "n", "<Leader>R", "<Cmd>lua vim.lsp.buf.rename()<CR>", opts)
    map_buf(bufnr, "n", "[d", '<Cmd>lua vim.diagnostic.goto_prev({float={border="rounded"}})<CR>', opts)
    map_buf(bufnr, "n", "]d", '<Cmd>lua vim.diagnostic.goto_next({float={border="rounded"}})<CR>', opts)
    map_buf(bufnr, "n", "<Leader>Wa", "<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
    map_buf(bufnr, "n", "<Leader>Wr", "<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
    map_buf(bufnr, "n", "<Leader>Wl", "<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)

    -- Set some keybinds conditional on server capabilities
    map_buf(bufnr, "v", "<Leader>f", "<Cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    map_buf(bufnr, "n", "<Leader>f", "<Cmd>lua vim.lsp.buf.format()<CR>", opts)

    -- Set up some keybindings to toggle LSP diagnostic visibility
    local lsp_diagnostics_active = true
    vim.keymap.set('n', "<F5>", function()
        lsp_diagnostics_active = not lsp_diagnostics_active
        if lsp_diagnostics_active then
            vim.diagnostic.show()
            vim.notify("LSP diagnostics enabled", "info", { title = "LSP" })
        else
            vim.diagnostic.hide()
            vim.notify("LSP diagnostics disabled", "info", { title = "LSP" })
        end
    end, opts)
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

-- Completion. In addition to what's already set up in nvim-cmp's standard config.
M.cmp = function ()
    local opts = { noremap = true, silent = true }
    local cmp_autopopup_enabled = true
    vim.keymap.set({'n', 'i'}, "<F4>", function()
        cmp_autopopup_enabled = not cmp_autopopup_enabled
        if cmp_autopopup_enabled then
            require("utils").EnableAutoCmp()
            vim.notify("Completion autopopups enabled", "info", { title = "nvim-cmp" })
        else
            require("utils").DisableAutoCmp()
            vim.notify("Completion autopopups disabled", "info", { title = "nvim-cmp" })
        end
    end, opts)
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

    -- Fast shortcuts to core Vim state
    map("n", m.telescope_, ":silent! Telescope<CR>", opt)
    map("n", m.buffers_, ":silent! Telescope buffers<CR>", opt)
    map("n", m.marks, ":silent! Telescope marks<CR>", opt)
    map("n", m.registers, ":silent! Telescope registers<CR>", opt)
    map("n", m.jumplist, ":silent! Telescope jumplist<CR>", opt)
    map("n", m.help_tags, ":silent! Telescope help_tags<CR>", opt)
    map("n", m.man_pages, ":silent! Telescope man_pages<CR>", opt)
    map("n", m.keymaps, ":silent! Telescope keymaps<CR>", opt)
    map("n", m.highlights, ":silent! Telescope highlights<CR>", opt)
    map("n", m.autocommands, ":silent! Telescope autocommands<CR>", opt)

    -- Pick snippet to preview and insert

    -- stylua: ignore
    map("n", m.select_snippet, ":silent! Telescope luasnip theme=get_dropdown layout_config={'height':0.5,'width':120}<CR>", opt)

    -- LSP
    map("n", m.lsp_diagnostics, ":Telescope diagnostics<CR>", opt)
    map("n", m.lsp_diagnostics_doc, ":Telescope diagnostics bufnr=0<CR>", opt)

    map("n", m.lsp_symbols, ":Telescope lsp_workspace_symbols<CR>", opt)
    map("n", m.lsp_symbols_doc, ":Telescope lsp_document_symbols<CR>", opt)

    map("n", m.lsp_definitions, ":Telescope lsp_definitions<CR>", opt)
    map("n", m.lsp_implementations, ":Telescope lsp_implementations<CR>", opt)
    map("n", m.lsp_references, ":Telescope lsp_references<CR>", opt)
    map("n", m.lsp_type_definitions, ":Telescope lsp_type_definitions<CR>", opt)

    -- Git objects
    map("n", m.git_commits, ":Telescope git_commits<CR>", opt)
    map("n", m.git_bcommits, ":Telescope git_bcommits<CR>", opt)
    map("n", m.git_branches, ":Telescope git_branches<CR>", opt)
    map("n", m.git_stash, ":Telescope git_stash<CR>", opt)
    map("n", m.git_files, ":Telescope git_files<CR>", opt)

    -- Lazygit
    map("n", m.lazygit, ":LazyGit<CR>", opt)

    map("n", m.spell_suggest, ":silent! Telescope spell_suggest<CR>", opt)
end

M.trouble = function()
    local m = user_map.trouble
    map("n", m.trouble, ":silent! TroubleToggle <CR>", opt)
end

M.fzf = function()
    local m = user_map.fzf
    map("n", m.fzf_files, ":silent! Files<CR>", opt)
    map("n", m.fzf_gfiles, ":silent! GFiles<CR>", opt)
    map("n", m.fzf_history, ":silent! History<CR>", opt)
    map("n", m.buffers, ":silent! Buffers<CR>", opt)
    map("n", m.windows, ":silent! Windows<CR>", opt)
    map("n", m.ripgrep, ":silent! Rg<CR>", opt)
end

-- Main ('misc') mappings are applied immediately
M.misc()

return M
