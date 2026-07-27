local present, ls = pcall(require, "luasnip")
if not present then
    return
end

local extras = require "luasnip.extras"
local postfix = require "luasnip.extras.postfix"

local d = ls.dynamic_node
local i = ls.insert_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local f = ls.function_node
local pf = postfix.postfix
local l = extras.lambda

-- ---------------------------------------------------------------------------
-- Helpers for the "today" diary entry snippet
-- ---------------------------------------------------------------------------

local _DIARY_PROPAGATED_SECTIONS = { "Context", "Priorities" }

local function _diary_today_heading()
    local days = { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" }
    local dt = os.date "*t"
    return string.format("### %s %02d/%02d", days[dt.wday], dt.day, dt.month)
end

-- Extract the content lines of a named section (#### SectionName) from a
-- list of lines belonging to a single diary entry.  Returns a list of
-- trimmed content lines, or nil if the section is absent or empty.
local function _diary_extract_section(entry_lines, section_name)
    local in_section = false
    local content = {}
    for _, line in ipairs(entry_lines) do
        if not in_section then
            -- Match "### SectionName" or "#### SectionName"
            if line:match("^###+ " .. section_name .. "%s*$") then
                in_section = true
            end
        else
            if line:match "^###" then
                break
            end
            table.insert(content, line)
        end
    end
    while #content > 0 and content[1] == "" do
        table.remove(content, 1)
    end
    while #content > 0 and content[#content] == "" do
        table.remove(content)
    end
    return #content > 0 and content or nil
end

-- Scan the current buffer for the most recent previous diary entry and
-- return a table mapping section name to copied section content.
-- Uses cursor position rather than date comparison, so duplicate or
-- misdated headings don't cause incorrect results.
local function _diary_prev_sections()
    local cursor_row = vim.api.nvim_win_get_cursor(0)[1] -- 1-indexed
    local all_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

    -- For newest-first files the previous entry sits below the cursor;
    -- fall back to scanning upward for oldest-first files.
    local prev_idx = nil
    for idx = cursor_row + 1, #all_lines do
        if all_lines[idx]:match "^### %a%a%a %d%d/%d%d" then
            prev_idx = idx
            break
        end
    end
    if not prev_idx then
        for idx = cursor_row - 1, 1, -1 do
            if all_lines[idx]:match "^### %a%a%a %d%d/%d%d" then
                prev_idx = idx
                break
            end
        end
    end

    if not prev_idx then
        return {}
    end

    local entry_lines = {}
    for idx = prev_idx + 1, #all_lines do
        if all_lines[idx]:match "^### %a%a%a %d%d/%d%d" then
            break
        end
        table.insert(entry_lines, all_lines[idx])
    end

    local sections = {}
    for _, section_name in ipairs(_DIARY_PROPAGATED_SECTIONS) do
        sections[section_name] = _diary_extract_section(entry_lines, section_name)
    end
    return sections
end

-- ---------------------------------------------------------------------------

ls.add_snippets("markdown", {

    -- Snippet overrides.  Overridden here, because I wasn't happy with the
    -- way whitespace was being handled in the LSP-format equivalents from
    -- friendly-snippets.

    s({ trig = "b", name = "Insert bold text", dscr = "Insert bold text", priority = 1010 }, {
        t "**",
        i(1, ""),
        t "**",
    }),

    s({ trig = "bold", name = "Insert bold text", dscr = "Insert bold text", priority = 1010 }, {
        t "**",
        i(1, ""),
        t "**",
    }),

    s({ trig = "i", name = "Insert italic text", dscr = "Insert italic text", priority = 1010 }, {
        t "_",
        i(1, ""),
        t "_",
    }),

    s({ trig = "italic", name = "Insert italic text", dscr = "Insert italic text", priority = 1010 }, {
        t "_",
        i(1, ""),
        t "_",
    }),

    s({ trig = "bi", name = "Insert bold italic text", dscr = "Insert bold italic text", priority = 1010 }, {
        t "***",
        i(1, ""),
        t "***",
    }),

    s({ trig = "link", name = "Links", dscr = "Add links", priority = 1010 }, {
        t "[",
        i(1, "label"),
        t "](",
        i(2, "url"),
        t ")",
    }),

    --
    -- Snippets to surround a selection
    --

    s({ trig = "bb", name = "Convert selection to bold", dscr = "Make selection bold" }, {
        t "**",
        f(function(_, snip)
            -- TM_SELECTED_TEXT is an array of lines.  Just use the first.
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        t "**",
    }),

    s({ trig = "ii", name = "Convert selection to italic", dscr = "Make selecton italic" }, {
        t "_",
        f(function(_, snip)
            -- TM_SELECTED_TEXT is an array of lines.  Just use the first.
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        t "_",
    }),

    s({ trig = "ll", name = "Convert selection to hyperlink", dscr = "Add links" }, {
        t "[",
        f(function(_, snip)
            -- TM_SELECTED_TEXT is an array of lines.  Just use the first.
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        t "](",
        i(1, { "url goes here" }),
        t ")",
    }),

    -- Convert selection into Sainsbury's JIRA link
    s({
        trig = "jj",
        name = "Convert selection to JIRA issue hyperlink",
        dscr = "Make selected JIRA ticket a hyperlink to issue",
    }, {
        t "[",
        f(function(_, snip)
            -- TM_SELECTED_TEXT is an array of lines.  Just use the first.
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        t "](https://sainsburys-tech.atlassian.net/browse/",
        f(function(_, snip)
            -- TM_SELECTED_TEXT is an array of lines.  Just use the first.
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        t '): "',
        i(1, { "title" }),
        t '"',
    }),

    -- POSTFIX: embolden a single word
    pf({
        trig = ".B",
        hidden = true,
    }, {
        f(function(_, parent)
            return "**" .. parent.snippet.env.POSTFIX_MATCH .. "**"
        end, {}),
    }),

    -- POSTFIX: italicise a single word
    pf({
        trig = ".I",
        hidden = true,
    }, {
        f(function(_, parent)
            return "_" .. parent.snippet.env.POSTFIX_MATCH .. "_"
        end, {}),
    }),

    -- POSTFIX: convert selection into Sainsbury's JIRA link
    pf({
        trig = ".j",
        match_pattern = "%a+-%d+",
        name = "Convert JIRA issue ID to link",
        dscr = "Make JIRA ID a link",
    }, {
        t "[",
        f(function(_, parent)
            return parent.snippet.env.POSTFIX_MATCH or {}
        end, {}),
        t "](https://sainsburys-tech.atlassian.net/browse/",
        f(function(_, parent)
            return parent.env.POSTFIX_MATCH
        end, {}),
        t ")",
    }, {}),

    -- Today's diary entry. Carries forward configured sections from the most
    -- recent previous entry found in the buffer.
    s({
        trig = "ND",
        name = "Insert today's diary entry",
        dscr = "Insert today's diary entry, carrying forward configured sections from the previous entry",
        priority = 1010,
    }, {
        f(function()
            local prev_sections = _diary_prev_sections()
            local lines = { _diary_today_heading(), "", "#### Achievements", "", "- ?" }
            for _, section_name in ipairs(_DIARY_PROPAGATED_SECTIONS) do
                vim.list_extend(lines, { "", "#### " .. section_name, "" })
                vim.list_extend(lines, prev_sections[section_name] or { "- ?" })
            end
            vim.list_extend(lines, {
                "", "#### Conversations", "", "- ?",
                "", "#### Notes", "", "- ?",
                "", "#### Reflections", "", "- ?",
                "", "",
            })
            return lines
        end, {}),
    }),
})
