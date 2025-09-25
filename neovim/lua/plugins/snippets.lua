return {
    {
        -- Snippets
        "L3MON4D3/LuaSnip",
        event = "BufEnter",
        build = (not jit.os:find "Windows")
                and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
            or "make install_jsregexp",
        dependencies = {
            "rafamadriz/friendly-snippets", -- LSP-format snippets
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
                require("luasnip.loaders.from_vscode").lazy_load { paths = { "./vscode-snippets" } }
            end,
        },
        config = function()
            local luasnip = require "luasnip"
            local types = require "luasnip.util.types"
            luasnip.config.setup {
                history = false,
                store_selection_keys = "<Tab>",
                ext_opts = {
                    [types.choiceNode] = {
                        active = {
                            virt_text = { { "●", "LuasnipChoiceNodeVirtualText" } },
                        },
                    },
                    [types.insertNode] = {
                        active = {
                            virt_text = { { "●", "LuasnipInsertNodeVirtualText" } },
                        },
                    },
                },
            }

            -- Advanced LuaSnip-native snippets (mine)
            require "snippets.luasnip"

            -- Keybindings

            -- (forwards)
            vim.keymap.set({"s"}, "<Tab>", function() luasnip.jump(1) end, {silent = true})
            vim.keymap.set({"i"}, "<Tab>", function()
                return luasnip.expand_or_jumpable() and "<Plug>luasnip-expand-or-jump" or "<Tab>"
            end, {silent = true, expr = true})

            -- (backwards)
            vim.keymap.set({"i", "s"}, "<S-Tab>", function() luasnip.jump(-1) end, {silent = true})

            -- for changing choices in choiceNodes (optional)
            vim.keymap.set({"i", "s"}, "<C-E>", function()
                if luasnip.choice_active() then
                    luasnip.change_choice(1)
                end
            end, {silent = true})

        end,
    },

}
