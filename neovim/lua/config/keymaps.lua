-- Key mappings

local M = {}

-- Global (non-plugin specific) mappings

-- Document keymapping groups in which-key.nvim
M.which_key_groups = {
    { "<leader>T", group = "Terminal" },
    { "<leader>c", group = "Commands" },
    { "<leader>g", group = "Git" },
    { "<leader>h", group = "GitSigns" },
    { "<leader>l", group = "LSP" },
    { "<leader>lw", group = "Workspace" },
    { "<leader>m", group = "Markdown" },
    { "<leader>p", group = "PackageMgmt" },
    { "<leader>t", group = "Telescope" },
    { "<leader>u", group = "UI" },
}

-- Keybindings, hoisted from the options and plugins configuration. Expose and
-- modify keybindings here.  Make sure you don't use same keys twice.

M.misc = {
    mapleader = " ",
    new_split = "<leader>-",
    new_vsplit = "<leader><bar>",
    new_terminal_quick = "<leader>TT",
    new_terminal_here = "<leader>Th",
    new_terminal_split = "<leader>Tx",
    new_terminal_vsplit = "<leader>Tv",
    write_file = "<M-s>",
}

M.packages = {
    mason = "<leader>pm",
    lazy = "<leader>pp",
    lazy_update = "<leader>pu",
    lazy_check = "<leader>pc",
    lazy_clean = "<leader>px",
    lazy_sync = "<leader>ps",
}

M.notify = {
    delete_all = "<leader>cn",
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

M.nvimtree = {
    treetoggle = "<C-n>", -- file manager
    treefocus = "<leader>F", -- file manager
}

M.lsp = {
    shortcuts = {
        format_doc = "<leader>f",
        format_range = "<leader>f",
        rename = "<leader>R",
        code_action = "<leader>a",
        source_action = "<leader>A",
    },

    line_diags = "<leader>cd",
    prev_line_diags = "<C-k>",
    next_line_diags = "<C-j>",
    info = "<leader>cl",
    definitions = "gd",
    declaration = "gD",
    type_definitions = "gy",
    next_error = "]e",
    prev_error = "[e",
    next_warning = "]w",
    prev_warning = "[w",
    format_doc = "<leader>cf",
    format_range = "<leader>cf",
    code_lens = "grc",
    source_action = "<leader>cA",
    toggle_inlay_hints = "<leader>ci",
}

-- Telescope-specific mapping: help etc
M.telescope = {
    shortcuts = {
        select_snippet = "<M-i>",
    },

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
    select_snippet = "<leader>ts",

    -- LSP
    lsp_diagnostics = "<leader>lwD",
    lsp_diagnostics_doc = "<leader>lD",

    lsp_symbols = "<leader>lws",
    lsp_symbols_doc = "<leader>ls",

    lsp_definitions = "<leader>ld",
    lsp_implementations = "<leader>li",
    lsp_references = "<leader>lr",
    lsp_type_definitions = "<leader>lt",

    -- Git objects
    git_commits = "<leader>gL",
    git_bcommits = "<leader>gl",
    git_branches = "<leader>gb",
    git_stash = "<leader>gs",
    git_files = "<leader>gf",

    markdown_headings = "<leader>mh",

    spell_suggest = "z=",
}

M.lazygit = {
    lazygit = "<leader>G",
}

M.fzf = {
    buffers = "<M-e>",
    files = "<C-p>", -- quick file access
    gfiles = "<M-p>", -- quick file access (Git)
    history = "<M-o>", -- quick file access (history)
    ripgrep = "<Leader>r", -- search everywhere (but fast)
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
    loclist = "<leader>hl",
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

-----------------------------------------------------------------------
--  More-complex customisations
--

-- Fast terminals
local shell = vim.env.SHELL
vim.keymap.set("n", M.misc.new_terminal_quick, string.format(":15sp term://%s<CR>", shell), { silent = true })
vim.keymap.set("n", M.misc.new_terminal_here, ":terminal<CR>", { silent = true })
vim.keymap.set("n", M.misc.new_terminal_split, string.format(":sp term://%s<CR>", shell), { silent = true })
vim.keymap.set("n", M.misc.new_terminal_vsplit, string.format(":vsp term://%s<CR>", shell), { silent = true })

-- Fast window splits
vim.keymap.set("n", M.misc.new_split, ":split<cr>", { silent = true })
vim.keymap.set("n", M.misc.new_vsplit, ":vsplit<cr>", { silent = true })

-- Fast access to Lazy.nvim
vim.keymap.set("n", M.packages.lazy, ":Lazy<cr>", { silent = true })
vim.keymap.set("n", M.packages.lazy_update, ":Lazy update<cr>", { silent = true })
vim.keymap.set("n", M.packages.lazy_check, ":Lazy check<cr>", { silent = true })
vim.keymap.set("n", M.packages.lazy_clean, ":Lazy clean<cr>", { silent = true })
vim.keymap.set("n", M.packages.lazy_sync, ":Lazy sync<cr>", { silent = true })

-- Leave selection intact in visual mode, for faster indenting
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

-- Fast file save
vim.keymap.set("n", M.misc.write_file, ":update<cr>", { silent = true })
vim.keymap.set("i", M.misc.write_file, "<esc>:update<cr>", { silent = true })

-- Use 'cabbrev' to correct common typos.  I accidentally type :W instead of :w, and get :Windows (fzf)
-- NOTE: no Lua equivalent of cabbrev exists yet.
vim.cmd [[ cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W')) ]]
vim.cmd [[ cabb w1 update ]]
vim.cmd [[ cabb W1 update ]]

-- Trick: <c-l> in INSERT mode, attempts to fix the last spelling error
vim.keymap.set("i", "<c-l>", "<c-g>u<Esc>[s1z=`]a<c-g>u", { silent = true })

return M
