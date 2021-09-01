-- Handwritten statusline
-- Based on <https://elianiva.my.id/post/neovim-lua-statusline>

local fn = vim.fn
local api = vim.api

local enabled_plugins_present, enabled_plugins = pcall(require, "pluginsEnabled")
if not enabled_plugins_present or (enabled_plugins.plugin_status.statusline == false) then
    return
end

local lsp_status_present, lsp_status = pcall(require, "lsp-status")

local M = {}

-- possible values are 'arrow' | 'rounded' | 'blank'
local active_sep = "custom"

-- change them if you want to different separator
M.separators = {
    arrow = { "", "" },
    arrow_light = { "", "" },
    rounded = { "", "" },
    blank = { "", "" },
    custom = { "", "" },
}

-- highlight groups
M.colors = {
    active = "%#StatusLine#",
    inactive = "%#StatuslineNC#",
    mode = "%#Mode#",
    mode_alt = "%#ModeAlt#",
    git = "%#Git#",
    git_alt = "%#GitAlt#",
    filetype = "%#Filetype#",
    filetype_alt = "%#FiletypeAlt#",
    line_info = "%#LineCol#",
    line_info_alt = "%#LineColAlt#",
}

M.lsp_diags_hl_group_prefix = "StatusLine"

M.lsp_diags_config = {
    errors = {
        key = "Error",
        icon = "",
    },
    warnings = {
        key = "Warning",
        icon = "",
    },
    info = {
        key = "Information",
        icon = "",
    },
    hints = {
        key = "Hint",
        icon = "",
    },
}

M.lsp_last_message = ""

M.git_icon = ""

M.git_show_changes = false

-- HACK: make all highlight groups the default color for now
-- stylua: ignore
api.nvim_exec( [[
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
    mode = 80,
    git_status = 90,
    lsp_diags = 90,
    filename = 140,
    line_info = 60,
}, {
    __index = function()
        return 80
    end,
})

M.is_truncated = function(_, width)
    local current_width = api.nvim_win_get_width(0)
    return current_width < width
end

M.modes = setmetatable({
    ["n"] = { "Normal", "N" },
    ["no"] = { "N·Pending", "N·P" },
    ["v"] = { "Visual", "V" },
    ["V"] = { "V·Line", "V·L" },
    [""] = { "V·Block", "V·B" }, -- this is not ^V, but it's , they're different
    ["s"] = { "Select", "S" },
    ["S"] = { "S·Line", "S·L" },
    [""] = { "S·Block", "S·B" }, -- same with this one, it's not ^S but it's 
    ["i"] = { "Insert", "I" },
    ["ic"] = { "Insert", "I" },
    ["R"] = { "Replace", "R" },
    ["Rv"] = { "V·Replace", "V·R" },
    ["c"] = { "Command", "C" },
    ["cv"] = { "Vim·Ex ", "V·E" },
    ["ce"] = { "Ex ", "E" },
    ["r"] = { "Prompt ", "P" },
    ["rm"] = { "More ", "M" },
    ["r?"] = { "Confirm ", "C" },
    ["!"] = { "Shell ", "S" },
    ["t"] = { "Terminal ", "T" },
}, {
    __index = function()
        return { "Unknown", "U" } -- handle edge cases
    end,
})

M.use_long_modes = false

M.get_current_mode = function(self)
    local current_mode = api.nvim_get_mode().mode

    if not self.use_long_modes or self:is_truncated(self.trunc_width.mode) then
        return string.format(" %s ", self.modes[current_mode][2]):upper()
    end
    return string.format(" %s ", self.modes[current_mode][1]):upper()
end

M.get_git_status = function(self)
    -- use fallback because it doesn't set this variable on the initial `BufEnter`
    local signs = vim.b.gitsigns_status_dict or { head = "", added = 0, changed = 0, removed = 0 }
    local is_head_empty = signs.head ~= ""

    if not self.git_show_changes or self:is_truncated(self.trunc_width.git_status) then
        return is_head_empty and string.format(" %s %s ", self.git_icon, signs.head or "") or ""
    end

    return is_head_empty
            and string.format(
                " %s %s | +%s ~%s -%s ",
                self.git_icon,
                signs.head,
                signs.added,
                signs.changed,
                signs.removed
            )
        or ""
end

M.get_filename = function(_)
    return "%<%f"
end

M.get_filetype = function()
    local file_name, file_ext = fn.expand "%:t", fn.expand "%:e"
    local icon = require("nvim-web-devicons").get_icon(file_name, file_ext, { default = true })
    local filetype = vim.bo.filetype

    if filetype == "" then
        return nil, nil
    end
    return icon, filetype
end

M.format_filename = function(_, icon, name)
    if name == nil then
        return ""
    end

    if icon == nil then
        return string.format(" %s ", name)
    else
        return string.format(" %s %s ", icon, name)
    end
end

M.format_filetype = function(_, icon, label)
    if label == nil then
        return ""
    end
    return string.format(" %s %s ", icon, label):lower()
end

M.get_line_info = function(self)
    if self:is_truncated(self.trunc_width.line_info) then
        return " %{line('.')}:%-2v %{line('$')}L "
    else
        return " %{line('.')}:%-2v %p%% %{line('$')}L "
    end
end

M.set_active = function(self)
    local colors = self.colors

    local mode = colors.mode .. self:get_current_mode()
    local mode_alt = colors.mode_alt .. self.separators[active_sep][1]
    local filetype_icon, filetype_label = self:get_filetype()
    local filename = colors.active .. self:format_filename(filetype_icon, self:get_filename())
    local lsp_diagnostic = self:get_lsp_diagnostic()
    local git = colors.git .. self:get_git_status()
    local git_alt = colors.git_alt .. self.separators[active_sep][2]
    local filetype_alt = colors.filetype_alt .. self.separators[active_sep][2]
    local filetype = colors.filetype .. self:format_filetype(filetype_icon, filetype_label)
    local line_info = colors.line_info .. self:get_line_info()
    local line_info_alt = colors.line_info_alt .. self.separators[active_sep][2]

   -- stylua: ignore
    return table.concat({
      -- left hand side
        colors.active, filename,
        "%=",
        -- leave centre vacant
        "%=",
      -- right hand side
        lsp_diagnostic, git_alt, git, filetype_alt, filetype, line_info_alt, line_info,
    })
end

M.set_inactive = function(self)
    return self.colors.inactive .. ""

    -- (Example code:)
    -- '%= %F %='

    -- (Vim default:)
    -- :set statusline=%f\ %h%w%m%r\ %=%(%l,%c%V\ %=\ %P%)
end

M.set_explorer = function(self)
    local title = self.colors.mode .. "   "
    local title_alt = self.colors.mode_alt .. self.separators[active_sep][2]

    return table.concat { self.colors.active, title, title_alt }
end

Statusline = setmetatable(M, {
    __call = function(statusline, mode)
        if mode == "active" then
            return statusline:set_active()
        end
        if mode == "inactive" then
            return statusline:set_inactive()
        end
        if mode == "explorer" then
            return statusline:set_explorer()
        end
    end,
})

-- set statusline
-- TODO: replace this once we can define autocmd using lua
-- stylua: ignore
api.nvim_exec( [[
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
    -- Check that lsp-status.nvim is loaded
    if not lsp_status_present then
        return ""
    end

    local function isempty(s)
        return s == nil or s == ""
    end

    -- Messages; just write them out
    local messages = lsp_status.messages()
    for _, msg in ipairs(messages) do
        -- DEBUG: print(vim.inspect(msg))
        fmt_msg = ""
        if not isempty(msg.title) or not isempty(msg.message) then
            if not isempty(msg.title) and not isempty(msg.message) then
                str = string.format("%s: %s", msg.title, msg.message)
            elseif not isempty(msg.message) then
                str = msg.message
            else
                str = msg.title
            end

            if msg.percentage ~= nil then
                fmt_msg = string.format("[LSP] %s: %s (%s%%)", msg.name, str, math.floor(msg.percentage))
            else
                fmt_msg = string.format("[LSP] %s: %s", msg.name, str)
            end
        end
        if fmt_msg ~= self.lsp_last_message then
            print(fmt_msg)
        end
        self.lsp_last_message = fmt_msg
    end

    -- Statusline too short
    if self:is_truncated(self.trunc_width.lsp_diags) then
        return ""
    end

    -- LSP supported, but not connected
    if #vim.lsp.buf_get_clients() == 0 then
        return " "
    end

    -- Otherwise, fish out and display stats-    local lsp_status = ""
    local lsp_status_str = ""

    for key, level in pairs(self.lsp_diags_config) do
        local count = lsp_status.diagnostics()[key]
        if count > 0 then
             -- stylua: ignore
            lsp_status_str =
                " " ..
                    lsp_status_str ..
                    "%#" .. M.lsp_diags_hl_group_prefix .. level.key .. "#" ..
                    level.icon .. " " .. count ..
                " "
        end
    end
    if lsp_status_str ~= "" then
        return lsp_status_str
    else
        -- No errors
        return " %#" .. M.lsp_diags_hl_group_prefix .. "Ok#" .. "  "
    end
end
