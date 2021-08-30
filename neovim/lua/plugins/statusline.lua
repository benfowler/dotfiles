-- Handwritten statusline
-- Based on <https://elianiva.my.id/post/neovim-lua-statusline>

local present, enabled_plugins = pcall(require, 'pluginsEnabled')
if not present or (enabled_plugins.plugin_status.statusline == false) then return end


local fn = vim.fn
local api = vim.api

local M = {}


-- possible values are 'arrow' | 'rounded' | 'blank'
local active_sep = 'blank'

-- change them if you want to different separator
M.separators = {
  arrow = { '', '' },
  rounded = { '', '' },
  blank = { '', '' },
}

-- highlight groups
M.colors = {
  active        = '%#StatusLine#',
  inactive      = '%#StatuslineNC#',
  mode          = '%#Mode#',
  mode_alt      = '%#ModeAlt#',
  git           = '%#Git#',
  git_alt       = '%#GitAlt#',
  filetype      = '%#Filetype#',
  filetype_alt  = '%#FiletypeAlt#',
  line_col      = '%#LineCol#',
  line_col_alt  = '%#LineColAlt#',
}

M.lsp_diags_hl_group_prefix = 'StatusLine'

M.lsp_diags_config = {
  errors = {
    key = 'Error',
    icon = '',
  },
  warnings = {
    key = 'Warning',
    icon = '',
  },
  info = {
    key = 'Information',
    icon = '',
  },
  hints = {
    key = 'Hint',
    icon = '',
  },
}

-- HACK: make all highlight groups the default color for now
api.nvim_exec([[
" hi! link StatusLine Mode
" hi! link StatusLine ModeAlt
" hi! link StatusLine Git
" hi! link StatusLine GitAlt
" hi! link StatusLine Filetype
" hi! link StatusLine FiletypeAlt
" hi! link StatusLine LineCol
" hi! link StatusLine LineColAlt
]], false)

M.trunc_width = setmetatable({
  mode       = 80,
  git_status = 90,
  lsp_diags  = 90,
  filename   = 140,
  line_col   = 60,
}, {
  __index = function()
      return 80
  end
})

M.is_truncated = function(_, width)
  local current_width = api.nvim_win_get_width(0)
  return current_width < width
end

M.modes = setmetatable({
  ['n']  = {'Normal', 'N'};
  ['no'] = {'N·Pending', 'N·P'} ;
  ['v']  = {'Visual', 'V' };
  ['V']  = {'V·Line', 'V·L' };
  [''] = {'V·Block', 'V·B'}; -- this is not ^V, but it's , they're different
  ['s']  = {'Select', 'S'};
  ['S']  = {'S·Line', 'S·L'};
  [''] = {'S·Block', 'S·B'}; -- same with this one, it's not ^S but it's 
  ['i']  = {'Insert', 'I'};
  ['ic'] = {'Insert', 'I'};
  ['R']  = {'Replace', 'R'};
  ['Rv'] = {'V·Replace', 'V·R'};
  ['c']  = {'Command', 'C'};
  ['cv'] = {'Vim·Ex ', 'V·E'};
  ['ce'] = {'Ex ', 'E'};
  ['r']  = {'Prompt ', 'P'};
  ['rm'] = {'More ', 'M'};
  ['r?'] = {'Confirm ', 'C'};
  ['!']  = {'Shell ', 'S'};
  ['t']  = {'Terminal ', 'T'};
}, {
  __index = function()
      return {'Unknown', 'U'} -- handle edge cases
  end
})

M.get_current_mode = function(self)
  local current_mode = api.nvim_get_mode().mode

  if self:is_truncated(self.trunc_width.mode) then
    return string.format(' %s ', self.modes[current_mode][2]):upper()
  end
  return string.format(' %s ', self.modes[current_mode][1]):upper()
end

M.get_git_status = function(self)
  -- use fallback because it doesn't set this variable on the initial `BufEnter`
  local signs = vim.b.gitsigns_status_dict or {head = '', added = 0, changed = 0, removed = 0}
  local is_head_empty = signs.head ~= ''

  if self:is_truncated(self.trunc_width.git_status) then
    return is_head_empty and string.format('  %s ', signs.head or '') or ''
  end

  return is_head_empty and string.format(
    ' +%s ~%s -%s |  %s ',
    signs.added, signs.changed, signs.removed, signs.head
  ) or ''
end

M.get_filename = function(self)
  if self:is_truncated(self.trunc_width.filename) then return " %<%f " end
  return " %<%F "
end

M.get_filetype = function()
  local file_name, file_ext = fn.expand("%:t"), fn.expand("%:e")
  local icon = require'nvim-web-devicons'.get_icon(file_name, file_ext, { default = true })
  local filetype = vim.bo.filetype

  if filetype == '' then return nil, nil end
  return icon, filetype
end

M.format_filetype = function(_, icon, label)
  if label == nil then return '' end
  return string.format(' %s %s ', icon, label):lower()
end

M.get_line_col = function(self)
  if self:is_truncated(self.trunc_width.line_col) then return ' %l:%c ' end
  return ' Ln %l, Col %c '
end


M.set_active = function(self)
  local colors = self.colors

  local mode = colors.mode .. self:get_current_mode()
  local mode_alt = colors.mode_alt .. self.separators[active_sep][1]
  local git = colors.git .. self:get_git_status()
  local git_alt = colors.git_alt .. self.separators[active_sep][1]
  local filetype_icon, filetype_label = self:get_filetype()
  local filename = colors.active .. self:get_filename()
  local lsp_diagnostic = self:get_lsp_diagnostic()
  local filetype_alt = colors.filetype_alt .. self.separators[active_sep][2]
  local filetype = colors.filetype .. self:format_filetype(filetype_icon, filetype_label)
  local line_col = colors.line_col .. self:get_line_col()
  local line_col_alt = colors.line_col_alt .. self.separators[active_sep][2]

  return table.concat({
    colors.active, mode, mode_alt, git, git_alt,
    "%=", filename, "%=",
    lsp_diagnostic, filetype_alt, filetype, line_col_alt, line_col
  })
end

M.set_inactive = function(self)
  return self.colors.inactive .. ''

  -- (Example code:)
  -- '%= %F %='

  -- (Vim default:)
  -- :set statusline=%f\ %h%w%m%r\ %=%(%l,%c%V\ %=\ %P%)
end

M.set_explorer = function(self)
  local title = self.colors.mode .. '   '
  local title_alt = self.colors.mode_alt .. self.separators[active_sep][2]

  return table.concat({ self.colors.active, title, title_alt })
end

Statusline = setmetatable(M, {
  __call = function(statusline, mode)
    if mode == "active" then return statusline:set_active() end
    if mode == "inactive" then return statusline:set_inactive() end
    if mode == "explorer" then return statusline:set_explorer() end
  end
})

-- set statusline
-- TODO: replace this once we can define autocmd using lua
api.nvim_exec([[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline('active')
  au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline('inactive')
  au WinEnter,BufEnter,FileType NvimTree setlocal statusline=%!v:lua.Statusline('explorer')
  augroup END
]], false)

----[[
--  NOTE: I don't use this since the statusline already has
--  so much stuff going on. Feel free to use it!
--  credit: https://github.com/nvim-lua/lsp-status.nvim
--
--  I now use `tabline` to display these errors, go to `_bufferline.lua` if you
--  want to check that out
----]]
Statusline.get_lsp_diagnostic = function(self)

  -- Statusline too short
  if self:is_truncated(self.trunc_width.lsp_diags) then return '' end

  -- LSP supported, but not connected
  if #vim.lsp.buf_get_clients() == 0 then
    return ' '
  end

  -- Otherwise, fish out and display stats
  local lsp_status = ''

  for _, level in pairs(self.lsp_diags_config) do
    local count = vim.lsp.diagnostic.get_count(0, level.key)
    if count > 0 then
      lsp_status = lsp_status .. '%#' .. M.lsp_diags_hl_group_prefix .. level.key .. '#' .. level.icon .. ' ' .. count .. ' '
   end
  end

  if lsp_status ~= '' then
    return lsp_status
  else
    -- No errors
    return ' '
  end
end

