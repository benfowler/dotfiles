-- Handwritten statusline
-- Based on <https://elianiva.my.id/post/neovim-lua-statusline>

local fn = vim.fn
local api = vim.api

local icons = require("util").diagnostic_icons.outline

local M = {}

-- possible values are 'arrow' | 'rounded' | 'blank'
local active_sep = "custom3"

-- change them if you want to different separator
M.separators = {
    arrow = { "", "" },
    arrow_light = { "", "" },
    rounded = { "", "" },
    blank = { "", "" },
    custom = { "", "" },
    custom2 = { "│", "" },
    custom3 = { "", "" },
}

M.filetype_icon_overrides = {
    md = " ",
}

-- highlight groups
M.colors = {
    active = "%#StatusLine#",
    inactive = "%#StatuslineNC#",
    mode = "%#Mode#",
    mode_alt = "%#ModeAlt#",
    search_info = "%#SearchInfo#",
    git = "%#Git#",
    git_alt = "%#GitAlt#",
    git_add = "%#StatusLineAdd#",
    git_change = "%#StatusLineChange#",
    git_delete = "%#StatusLineDelete#",
    filetype = "%#Filetype#",
    filetype_alt = "%#FiletypeAlt#",
    line_info = "%#LineCol#",
    line_info_alt = "%#LineColAlt#",
}

M.lsp_diags_hl_group_prefix = "StatusLine"

M.lsp_diags_config = {
    errors = {
        key = "ERROR",
        icon = icons.error,
    },
    warnings = {
        key = "WARN",
        icon = icons.warn,
    },
    info = {
        key = "INFO",
        icon = icons.info,
    },
    hints = {
        key = "HINT",
        icon = icons.hint,
    },
}

M.lsp_last_message = ""

M.git_icon = ""

M.git_show_changes = true

M.lsp_show_status_messages = false


-- HACK: make all highlight groups the default color for now
-- stylua: ignore
api.nvim_exec([[
   " hi! link StatusLine Mode
   " hi! link StatusLine ModeAlt
   " hi! link StatusLine SearchInfo
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
    ["n"] = { "Normal", "N", "%#StatusLineModeNormal#" },
    ["no"] = { "N·Pending", "N·P", "%#StatusLineModeNormal#" },
    ["niI"] = { "N·Insert", "N·I", "%#StatusLineModeNormal#" }, -- C-o 'insert-normal' mode
    ["niR"] = { "N·Replace", "N·R", "%#StatusLineModeReplace#" }, -- C-o 'replace-normal' mode
    ["niV"] = { "N·Visual", "N·R", "%#StatusLineModeVisual#" }, -- C-o 'virtual-replace' mode
    ["nt"] = { "N·Terminal", "N·T", "%#StatusLineModeNormal#" },
    ["v"] = { "Visual", "V", "%#StatusLineModeVisual#" },
    ["V"] = { "V·Line", "V·L", "%#StatusLineModeVisual#" },
    [""] = { "V·Block", "V·B", "%#StatusLineModeVisual#" }, -- this is not ^V, but it's , they're different
    ["s"] = { "Select", "S", "%#StatusLineModeVisual#" },
    ["S"] = { "S·Line", "S·L", "%#StatusLineModeVisual#" },
    [""] = { "S·Block", "S·B", "%#StatusLineModeVisual#" }, -- same with this one, it's not ^S but it's 
    ["i"] = { "Insert", "I", "%#StatusLineModeInsert#" },
    ["ic"] = { "Insert", "I", "%#StatusLineModeInsert#" },
    ["ix"] = { "Insert", "I", "%#StatusLineModeInsert#" },
    ["R"] = { "Replace", "R", "%#StatusLineModeReplace#" },
    ["Rv"] = { "V·Replace", "V·R", "%#StatusLineModeReplace#" },
    ["c"] = { "Command", "C", "%#StatusLineModeCommand#" },
    ["cv"] = { "Vim·Ex ", "V·E", "%#StatusLineModeEx#" },
    ["ce"] = { "Ex ", "E", "%#StatusLineModeEx#" },
    ["r"] = { "Prompt ", "P", "%#StatusLineModeNormal#" },
    ["rm"] = { "More ", "M", "%#StatusLineModeNormal#" },
    ["r?"] = { "Confirm ", "C", "%#StatusLineModeNormal#" },
    ["!"] = { "Shell ", "S", "%#StatusLineModeTerminal#" },
    ["t"] = { "Terminal ", "T", "%#StatusLineModeTerminal#" },
}, {
    __index = function()
        return { "Unknown", "U" } -- handle edge cases
    end,
})

M.use_long_modes = true

M.get_current_mode = function(self)
    local current_mode = api.nvim_get_mode().mode

    local hl_group = self.modes[current_mode][3]
    if not self.use_long_modes or self:is_truncated(self.trunc_width.mode) then
        return string.format(" %s%s ", hl_group, self.modes[current_mode][2]):upper()
    end
    return string.format(" %s%s ", hl_group, self.modes[current_mode][1]):upper()
end

M.get_git_status = function(self)
    -- use fallback because it doesn't set this variable on the initial `BufEnter`
    local signs = vim.b.gitsigns_status_dict or { head = "", added = 0, changed = 0, removed = 0 }
    local is_head_empty = signs.head ~= ""

    if is_head_empty and not self:is_truncated(self.trunc_width.git_status) then
        local git_indicator = ""
        if signs.added ~= nil and signs.added > 0 then
            git_indicator = git_indicator .. " " .. self.colors.git_add .. "+" .. signs.added
        end
        if signs.changed ~= nil and signs.changed > 0 then
            git_indicator = git_indicator .. " " .. self.colors.git_change .. "~" .. signs.changed
        end
        if signs.removed ~= nil and signs.removed > 0 then
            git_indicator = git_indicator .. " " .. self.colors.git_delete .. "-" .. signs.removed
        end

        return git_indicator
    else
        return ""
    end
end

M.get_git_branch = function(self)
    -- use fallback because it doesn't set this variable on the initial `BufEnter`
    local signs = vim.b.gitsigns_status_dict or { head = "" }
    local is_head_empty = signs.head ~= ""

    return is_head_empty and string.format(" %s %s ", self.git_icon, signs.head or "") or ""
end

M.get_filename = function(_)
    return "%<%f"
end

M.get_filetype = function(self)
    local file_name, file_ext = fn.expand "%:t", fn.expand "%:e"
    local filetype = vim.bo.filetype
    if filetype == "" then
        return nil, nil
    end
    local icon = self.filetype_icon_overrides[file_ext]
    if icon == nil then
        icon = require("nvim-web-devicons").get_icon(file_name, file_ext, { default = true })
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
        -- TO ADD TOTAL LINE COUNT:: "%{line('$')}L"
        return " %{line('.')}:%-2v "
    else
        return " %{line('.')}:%-2v %p%% "
    end
end

M.get_search_info = function(_)
    local search = vim.fn.searchcount { maxcount = 0 } -- maxcount = 0 makes the number not be capped at 99
    local result = ""
    if search.total > 0 then
        result = " " .. search.current .. "/" .. search.total
    end
    return result
end

M.set_active = function(self)
    local colors = self.colors

    local mode = colors.mode .. self:get_current_mode()
    local mode_alt = colors.mode_alt .. self.separators[active_sep][1]
    local filetype_icon, filetype_label = self:get_filetype()
    local filename = colors.active .. self:get_filename()
    local lsp_diagnostic = self:get_lsp_diagnostic()
    local git_status = colors.git .. self:get_git_status()
    local git_branch = colors.git .. self:get_git_branch()
    local git_alt = colors.git_alt .. self.separators[active_sep][2]
    local filetype_alt = colors.filetype_alt .. self.separators[active_sep][2]
    local filetype = colors.filetype .. self:format_filetype(filetype_icon, filetype_label)
    --local search_info = colors.search_info .. self:get_search_info()
    local line_info = colors.line_info .. self:get_line_info()
    local line_info_alt = colors.line_info_alt .. self.separators[active_sep][2]

    -- stylua: ignore
    return table.concat({
        -- left hand side
        mode, mode_alt, colors.active, git_status,
        "%=",
        -- centre
        -- filename,
        "%=",
        -- right hand side
        lsp_diagnostic, git_alt, git_branch, filetype_alt, filetype, line_info_alt, line_info,
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

-- Entry point to this module
-- TODO: port to Lua
M.setup = function()
    -- stylua: ignore
    api.nvim_exec([[
        augroup Statusline
        au!
        au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline('active')
        au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline('inactive')
        au WinEnter,BufEnter,FileType NvimTree setlocal statusline=%!v:lua.Statusline('explorer')
        augroup END
    ]], false)
end

Statusline.get_lsp_diagnostic = function(self)
    local function isempty(s)
        return s == nil or s == ""
    end

    -- Statusline too short
    if self:is_truncated(self.trunc_width.lsp_diags) then
        return ""
    end

    -- LSP supported, but not connected
    if #vim.lsp.buf_get_clients() == 0 then
        return " %#" .. M.lsp_diags_hl_group_prefix .. "#" .. "󰈉  "
    end

    -- Otherwise, fish out and display stats
    local lsp_status_str = ""

    for key, level in pairs(self.lsp_diags_config) do
        local count = #vim.diagnostic.get(0, { severity = level.key })

        if count > 0 then
            -- stylua: ignore
            lsp_status_str = " " ..
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
        return " %#" .. M.lsp_diags_hl_group_prefix .. "Ok#" .. "󰈈  "
    end
end

M.setup()
