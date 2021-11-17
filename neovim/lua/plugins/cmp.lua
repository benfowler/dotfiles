
local cmp = require("cmp")
local luasnip = require("luasnip")

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

vim.opt.completeopt = "menu,menuone,noselect"

-- nvim-cmp setup
cmp.setup {
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    formatting = {
        format = require("lspkind").cmp_format {
            with_text = true,
            menu = {
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                luasnip = "[LuaSnip]",
                nvim_lua = "[Lua]",
            },
        },
    },
    completion = {
        autocomplete = false,
        keyword_length = 2,
    },
    mapping = {
        ["<C-Y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ["<C-K>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
        ["<C-J>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
        ["<C-D>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-F>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-E>"] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        },
        ["<CR>"] = cmp.mapping.confirm { select = true },
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
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
        { name = "luasnip" },
        { name = "buffer" },
        { name = "nvim_lua" },
    },
    experimental = {
        ghost_text = {
            hl_group = "Comment",
        },
    },
}

-- Use buffer source for `/` (if you enabled `native_menu`, this won"t work anymore).
cmp.setup.cmdline("/", {
    sources = {
        { name = "buffer" },
    },
})

-- Use cmdline & path source for ":" (if you enabled `native_menu`, this won"t work anymore).
cmp.setup.cmdline(":", {
    sources = cmp.config.sources({
        { name = "path" },
    }, {
        { name = "cmdline" },
    }),
})
