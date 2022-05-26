local cmp_loaded, cmp = pcall(require, "cmp")
if not cmp_loaded then
    return
end

local luasnip = require "luasnip"

local icons = require("lspkind").symbol_map

-- nvim-cmp setup
cmp.setup {
    experimental = {
        ghost_text = {
            hl_group = "Comment",
        },
    },
    confirmation = {
        get_commit_characters = function()
            return {}
        end,
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    completion = {
        completeopt = "menu,menuone,noinsert",
        keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
        keyword_length = 1,
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(_, vim_item)
            vim_item.menu = " " .. vim_item.kind
            vim_item.kind = icons[vim_item.kind]
            vim_item.abbr = string.sub(vim_item.abbr, 1, 45)  -- truncate items
            return vim_item
        end,
    },
    window = {
        documentation = cmp.config.window.bordered({ winhighlight = "CursorLine:PmenuSel" }),
    },
    view = {
        entries = { name = 'custom', selection_order = 'near_cursor' }
    },
    mapping = {
        ["<C-Y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ["<C-J>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
        ["<C-N>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
        ["<C-K>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
        ["<C-P>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
        ["<C-D>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-F>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-E>"] = cmp.mapping(function(fallback)
            if luasnip.choice_active() then
                luasnip.change_choice(1)
            else
                fallback()
            end
        end, { "i", "s", "c" }),
        ["<Esc>"] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        },
        ["<CR>"] = cmp.mapping.confirm { select = true },
        ["<Tab>"] = cmp.mapping(function(fallback)
            -- IntelliJ-like mapping (see nvim-cmp wiki)
            -- Confirm with tab, and if no entry is selected, confirm first item
            if cmp.visible() then
                local entry = cmp.get_selected_entry()
                if not entry then
                    cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
                else
                    cmp.confirm()
                end
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "path" },
        { name = "luasnip" },
        { name = "latex_symbols" },
        { name = "nvim_lsp_signature_help" },
    },
    preselect = cmp.PreselectMode.None,
}

