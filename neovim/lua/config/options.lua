vim.g.mapleader = " "
--
-- General options
-- stylua: ignore start
vim.opt.undofile = true                           -- permanent undo
vim.opt.visualbell = true                         -- disable beeps
vim.opt.showmode = false
--
vim.opt.switchbuf:append("useopen")               -- When using :sbuffer, jump to open window if available
--
vim.opt.updatetime = 2000                         -- number of milliseconds before CursorHold autocommand event fired
--
-- Enable the following to bind yank to system clipboard by default
-- CAVEAT: slows system startup, and makes 'x' overwrite the system clipboard
vim.opt.clipboard:append("unnamedplus")
--
-- Windows or WSL2: Requires equalsraf/win32yank.  try: choco install win32yank
if vim.fn.has('win16') == 1 or vim.fn.has('win32') == 1 then
  vim.g.clipboard = {
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
--
-- Appearance settings
vim.opt.termguicolors = true                      -- enable true colors support
vim.opt.signcolumn = "yes:1"                      -- make sign column grow automatically
--vim.opt.colorcolumn:append("81")                -- enable right-hand margin by default
--vim.opt.cursorline = true                       -- highlight cursor row
vim.opt.shortmess:append("a")
--
-- Mouse
vim.opt.mouse:append("a")
--
-- Turn off swapfiles and backups, like all the cool kids
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.wb = false
--
-- Indentation
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.shiftwidth = 4
vim.opt.expandtab = true                          -- soft tabs always!
vim.opt.tabstop = 4
vim.opt.shiftround = true                         -- use multiple of shiftwidth when indenting with > and <
--
vim.opt.breakindent = true                        -- soft wrapping: 'indent' wrapped text
vim.opt.breakindentopt = 'shift:2'
vim.opt.showbreak = '↳'
--
vim.opt.wrap = false                              -- most file types don't get wrapped by default
--
-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = 'screen'
--
-- Folding
vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
--
vim.opt.numberwidth = 1                           -- required for GitSigns to render in correct pos wrt folds, signs and numbers
vim.opt.foldenable = true                         --   "
vim.opt.foldcolumn = '0'                          --   "
vim.opt.foldlevel = 99                            --   "
--
-- Completions - basic settings
vim.opt.completeopt = "menu"                      -- Onmicomplete to not create annoying split when activated
vim.opt.pumheight = 12                            -- Pmenu max height
vim.opt.pumwidth = 30                             -- Pmenu _minimum_ width
vim.opt.pumblend = 5                              -- Pmenu pseudotransparency
--
vim.opt.wildmode = "full"
vim.opt.wildmenu = true                           -- enable ctrl-n and ctrl-p to scroll thru matches
--
vim.opt.wildignore = {
  "*.o,*.obj,*~",                                 -- stuff to ignore when tab completing
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
--
-- Scrolling
vim.opt.scrolloff = 3                             -- keep some lines visible
--
-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildignorecase = true
--
-- Hidden characters                              -- and mapping to switch it
vim.opt.listchars = "tab:»·,nbsp:␣,eol:↲,extends:»,precedes:«,trail:•"
--
-- Security
vim.opt.secure = true                             -- also load .vimrc from directory where Vim launched
--
if vim.env.SUDO_USER ~= nil then
  vim.opt.swapfile = false
  vim.opt.backup = false
  vim.opt.writebackup = false
  vim.opt.undofile = false
  vim.opt.shada = ''
end
--
-- stylua: ignore end
--
