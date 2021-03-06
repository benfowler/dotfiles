local present, lspkind = pcall(require, "lspkind")

if not present then
    return
end

lspkind.init {
    preset = "codicons",
    symbol_map = {
        Text = "",
        Method = "",
        Function = "",
        Constructor = "⌘",
        Field = "ﰠ",
        Variable = "",
        Class = "ﴯ",
        Interface = "",
        Module = "",
        Property = "ﰠ",
        Unit = "塞",
        Value = "",
        Enum = "",
        Keyword = "廓",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "פּ",
        Event = "",
        Operator = "",
        TypeParameter = "",
    },
}
