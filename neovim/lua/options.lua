local opt = vim.opt
local fn = vim.fn
local g = vim.g


-- General options
-- stylua: ignore start
opt.backspace = { "indent", "eol", "start" }  -- allow backspacing through anything
opt.undofile = true                           -- permanent undo
opt.number = false                            -- line numbering.  Hybrid mode.
opt.relativenumber = false
opt.showcmd = true                            -- set incomplete commands down the bottom
opt.visualbell = true                         -- disable beeps
opt.autoread = true                           -- read files from disk automatically if they've changed elsewhere
opt.cmdheight = 1
opt.showmode = true

opt.hidden = true                             -- lets Vim keep buffers in the background w/o a window
opt.switchbuf:append("useopen")               -- When using :sbuffer, jump to open window if available

opt.updatetime = 2000                         -- number of milliseconds before CursorHold autocommand event fired
opt.clipboard:append("unnamedplus")           -- bind yank to system clipboard by default

-- Windows or WSL2: Requires equalsraf/win32yank.  try: choco install win32yank
if fn.has('win16') == 1 or fn.has('win32') == 1 then
    g.clipboard = {
        name = 'win32yank-wsl',
        copy = {
            ['+'] = 'win32yank.exe -i --crlf',
            ['*'] = 'win32yank.exe -i --crlf',
        },
        paste = {
            ['+'] = 'win32yank.exe -o --lf',
            ['*'] = 'win32yank.exe -o --lf',
        },
        cache_enabled = 0,
    }
end

opt.nrformats= ''                             -- Force decimal-only for C-a and C-x

-- Appearance settings
opt.termguicolors = true                      -- enable true colors support
opt.signcolumn = "yes:1"                      -- make sign column grow automatically
opt.cul = false                               -- highlight cursor row
opt.shortmess:append("a")

-- Mouse
opt.mouse:append("a")

-- Turn off swapfiles and backups, like all the cool kids
opt.swapfile = false
opt.backup = false
opt.wb = false

-- Indentation
opt.autoindent = true
opt.smartindent = true
opt.smarttab = true
opt.shiftwidth = 4
opt.expandtab = true                          -- soft tabs always!
opt.tabstop = 4
opt.shiftround = true                         -- use multiple of shiftwidth when indenting with > and <

opt.breakindent = true                        -- soft wrapping: 'indent' wrapped text
opt.breakindentopt = 'shift:2'
opt.showbreak = '↳'

opt.wrap = false                              -- most file types don't get wrapped by default
opt.linebreak = false

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Folding
opt.foldmethod = "indent"
opt.foldnestmax = 3
opt.foldenable = false

--opt.whichwrap:append("<>hl")                  -- Traverse through EOLs

-- Completions - basic settings
opt.completeopt = "menu"                      -- Onmicomplete to not create annoying split when activated
opt.pumheight = 12                            -- Pmenu max height
opt.pumwidth = 30                             -- Pmenu _minimum_ width
opt.pumblend = 5                              -- Pmenu pseudotransparency

opt.wildmode = "full"
opt.wildmenu = true                           -- enable ctrl-n and ctrl-p to scroll thru matches

opt.wildignore = {
	"*.o,*.obj,*~",                            -- stuff to ignore when tab completing
	"*vim/backups*",
	"*sass-cache*",
	"*DS_Store*",
	"vendor/rails/**",
	"vendor/cache/**",
	"*.gem",
	"log/**",
	"tmp/**",
	"*.png,*.jpg,*.gif",
}

-- Scrolling
opt.scrolloff = 5                             -- keep some lines visible
opt.sidescrolloff = 5
opt.sidescroll = 1

-- Searching
opt.incsearch = true
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.wildignorecase = true

-- Hidden characters                          -- and mapping to switch it
opt.listchars = "tab:»·,nbsp:␣,eol:↲,extends:»,precedes:«,trail:•"

-- Security
opt.secure = true                             -- also load .vimrc from directory where Vim launched

-- stylua: ignore end

-- Disable builtin vim plugins
local disabled_built_ins = {
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

-- c-l in INSERT mode, attempts to fix the last spelling error
vim.cmd [[ inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u ]]

-- Useful custom command to yank current location
vim.cmd [[ command! YankLocation let @+ = join([expand('%'),  line(".")], ':') ]]

-- Autogroup for autocommands
-- stylua: ignore
vim.cmd [[
    augroup global_settings_options
    autocmd!

    " Open a file from its last left off position
    " See :help last-position-jump
    function! JumpToLastEditOnOpen()
    if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
        exe "normal! g`\""
    endif
    endfunction

    autocmd BufReadPost * call JumpToLastEditOnOpen()


    " I have a habit of accidentally typing :W instead of :w, and getting :Windows (fzf)
    cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))

    " Strip trailing whitespace on save for certain filetypes
    autocmd FileType markdown,c,cpp,java,py,lua,tex autocmd BufWritePre <buffer> %s/\s\+$//e

    " File extension-specific tabbing
    autocmd Filetype python,lua setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
    autocmd BufNewFile,BufRead *.go setlocal noet ts=4 sw=4 sts=4

    " Don't show status line on certain windows
    let g:hidden_statusline = [ 'NvimTree', ]

    function! HideStatusbarOnOpen()
    if index(g:hidden_statusline, &ft) >= 0
        set laststatus=0
    else
        set laststatus=2
    endif
    endfunction

    autocmd BufEnter,BufWinEnter,WinEnter,CmdwinEnter,TermEnter * nested call HideStatusbarOnOpen()

    "
    " NeoVim's terminal defaults are bad; fix them
    "

    " Don't show any numbers inside terminals
    autocmd TermOpen term://* setlocal nonumber norelativenumber
    autocmd TermOpen term://* setfiletype terminal

    " Open new terminals in insert mode
    autocmd TermOpen term://* startinsert

    " If terminal is running default shell, I don't care about the exit status
    autocmd TermClose $SHELL\|zsh :bd

    augroup END
]]


-- File-specific settings: Markdown
-- stylua: ignore
vim.cmd [[
    augroup filetype_markdown
    autocmd!

    autocmd FileType markdown set pumheight=7

    autocmd FileType markdown set conceallevel=2
    autocmd FileType markdown set textwidth=80

    " Spelling corrections from dict in omnicomplete by default
    autocmd FileType markdown set complete+=k
    autocmd FileType markdown set dictionary+=/usr/share/dict/words

    "
    " TODO: move to mappings and migrate once autogroup Lua bindings exist
    "

    autocmd FileType markdown nnoremap <leader>mm :silent !open -a Marked\ 2.app '%:p'<cr>
    autocmd FileType markdown nnoremap <leader>mh :Telescope heading theme=get_dropdown<cr>

    augroup END
]]

