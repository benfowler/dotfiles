local opt = vim.opt
local g = vim.g


-- General options
opt.backspace = { "indent", "eol", "start" }  -- allow backspacing through anything
opt.undofile = true                           -- permanent undo
opt.number = true                             -- line numbering
opt.relativenumber = false
opt.showcmd = true                            -- set incomplete commands down the bottom
opt.visualbell = true                         -- disable beeps
opt.autoread = true                           -- read files from disk automatically if they've changed elsewhere
opt.cmdheight = 2                             -- reduce 'Press ENTER or type command' prompts

opt.hidden = true                             -- lets Vim keep buffers in the background w/o a window

opt.updatetime = 2000                         -- number of milliseconds before CursorHold autocommand event fired
opt.clipboard = "unnamed"                     -- bind yank to system clipboard by default


-- Appearance settings
opt.termguicolors = true                      -- enable true colors support
opt.signcolumn = "auto:1"                     -- make sign column grow automatically
opt.cul = false                               -- highlight cursor row
opt.colorcolumn = { 81 }
opt.shortmess:append "a"


-- Mouse
opt.mouse:append "a"

-- Turn off swapfiles and backups, like all the cool kids
opt.swapfile = false
opt.backup = false
opt.wb = false


-- Indentation
opt.autoindent = true
opt.smartindent = true
opt.smarttab = true
opt.shiftwidth = 4
opt.expandtab = true             -- soft tabs always!
opt.tabstop = 4
opt.shiftround = true            -- use multiple of shiftwidth when indenting with > and <

opt.wrap = false
opt.linebreak = true


-- Completions - basic settings
opt.pumheight = 12               -- Pmenu max height
opt.pumwidth = 30                -- Pmenu _minimum_ width

opt.wildmode = "full"
opt.wildmenu = true              -- enable ctrl-n and ctrl-p to scroll thru matches

opt.wildignore = "*.o,*.obj,*~"  -- stuff to ignore when tab completing
opt.wildignore:append "*vim/backups*"
opt.wildignore:append "*sass-cache*"
opt.wildignore:append "*DS_Store*"
opt.wildignore:append "vendor/rails/**"
opt.wildignore:append "vendor/cache/**"
opt.wildignore:append "*.gem"
opt.wildignore:append "log/**"
opt.wildignore:append "tmp/**"
opt.wildignore:append "*.png,*.jpg,*.gif"


-- Scrolling
opt.scrolloff = 5                -- keep some lines visible
opt.sidescrolloff = 15
opt.sidescroll = 1


-- Searching
opt.incsearch = true
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.wildignorecase = true


-- Security
opt.secure = true                -- also load .vimrc from directory where Vim launched
opt.modelines = 0
opt.modeline = false


-- Disable builtin vim plugins
local disabled_built_ins = {
   "netrw",
   "netrwPlugin",
   "netrwSettings",
   "netrwFileHandlers",
   "gzip",
   "zip",
   "zipPlugin",
   "tar",
   "tarPlugin",
   "getscript",
   "getscriptPlugin",
   "vimball",
   "vimballPlugin",
   "2html_plugin",
   "logipat",
   "rrhelper",
   "spellfile_plugin",
   "matchit",
}

for _, plugin in pairs(disabled_built_ins) do
   g["loaded_" .. plugin] = 1
end


-- Don't show any numbers inside terminals
vim.cmd [[ au TermOpen term://* setlocal nonumber norelativenumber ]]


-- Don't show status line on certain windows
vim.cmd [[ au TermOpen term://* setfiletype terminal ]]
vim.cmd [[ let hidden_statusline = [ 'NvimTree', 'terminal' ] | autocmd BufEnter,BufWinEnter,WinEnter,CmdwinEnter,TermEnter * nested if index(hidden_statusline, &ft) >= 0 | set laststatus=0 | else | set laststatus=2 | endif ]]


-- Open a file from its last left off position
vim.cmd [[ au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]]


-- File extension-specific tabbing
vim.cmd [[ autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4 ]]

