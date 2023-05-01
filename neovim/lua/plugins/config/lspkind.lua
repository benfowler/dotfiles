local present, lspkind = pcall(require, "lspkind")

if not present then
    return
end

lspkind.init {
    preset = "codicons",
    symbol_map = {
        Text = "",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "⌘",
        Field = "󰜢",
        Variable = "󰈜",
        Class = "󰠱",
        Interface = "",
        Module = "󰏓",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰔌",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "",
        EnumMember = "",
        Constant = "󰐀",
        Struct = "󰙅",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "",
    },
}
