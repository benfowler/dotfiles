local present, luasnip = pcall(require, "luasnip")
if not present then
    return
end

local types = require "luasnip.util.types"
luasnip.config.set_config {
    history = true, -- 'true' is annoying
    delete_check_events = "InsertLeave,TextChanged",
    updateevents = "InsertLeave,TextChanged,TextChangedI",
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

-- LuaSnip-native snippets (mine)
require("plugins.config.luasnip.markdown")

-- friendly-snippets (LSP-format) snippets
require("luasnip/loaders/from_vscode").load()
require("luasnip/loaders/from_vscode").load { paths = { "./vscode-snippets" } }

