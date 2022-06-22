local present, ls = pcall(require, "luasnip")
if not present then
    return
end

local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node
local f = ls.function_node


ls.add_snippets("markdown", {

    -- Snippet overrides.  Overridden here, because I wasn't happent with the
    -- way whitespace was being handled in the LSP-format equivalents from
    -- friendly-snippets.

    s({ trig = "b", name = "Insert bold text", dscr="Insert bold text", priority=1010 }, {
        t("**"), i(1, ""), t("**")
    }),

    s({ trig = "bold", name = "Insert bold text", dscr = "Insert bold text", priority=1010 }, {
        t("**"), i(1, ""), t("**")
    }),

    s({ trig = "i", name = "Insert italic text", dscr = "Insert italic text", priority=1010 }, {
        t("_"), i(1, ""), t("_")
    }),

    s({ trig = "italic", name = "Insert italic text", dscr = "Insert italic text", priority=1010 }, {
        t("_"), i(1, ""), t("_")
    }),

    s({ trig = "bi", name = "Insert bold italic text", dscr = "Insert bold italic text", priority=1010 }, {
        t("***"), i(1, ""), t("***")
    }),

    s({ trig = "link", name = "Links", dscr="Add links", priority=1010 }, {
        t("["), i(1, "label"), t("]("), i(2, "url"), t(")")
    }),


    --
    -- Snippets to surround a selection
    --

    s({ trig = "bb", name = "Make selection bold", dscr = "Make selection bold" }, {
        t('**'),
        f(function(_, snip)
            -- TM_SELECTED_TEXT is an array of lines.  Just use the first.
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        t('**')
    }),

    s({ trig = "ii", name = "Make selection italic", dscr = "Make selecton italic" }, {
        t('_'),
        f(function(_, snip)
            -- TM_SELECTED_TEXT is an array of lines.  Just use the first.
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        t('_')
    }),

    s({ trig = "ll", name = "Make selection hyperlink", dscr = "Add links" }, {
        t('['),
        f(function(_, snip)
            -- TM_SELECTED_TEXT is an array of lines.  Just use the first.
            return snip.env.TM_SELECTED_TEXT[1] or {}
        end, {}),
        t(']('),
        i(1, { "url goes here" }),
        t(')')
    })
})

