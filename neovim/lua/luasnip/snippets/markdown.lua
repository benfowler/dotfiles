local present, ls = pcall(require, "luasnip")
if not present then
    return
end

local extras = require "luasnip.extras"
local postfix = require "luasnip.extras.postfix"

local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node
local f = ls.function_node
local pf = postfix.postfix
local l = extras.lambda

ls.add_snippets("markdown", {

    -- Snippet overrides.  Overridden here, because I wasn't happent with the
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
        t "](https://sainsburys-jira.valiantys.net/browse/",
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
        t "](https://sainsburys-jira.valiantys.net/browse/",
        f(function(_, parent)
            return parent.env.POSTFIX_MATCH
        end, {}),
        t ")",
    }, {}),
})
