
---@type vim.lsp.Config
return {
  settings = {
    texlab = {
      build = {
        -- See `tectonic --help` for the format
        executable = "tectonic",
        args = {
          -- Input
          "%f",
          -- Flags
          "--synctex",
          "--keep-logs",
          "--keep-intermediates",
          -- Options
          -- OPTIONAL: If you want a custom out directory,
          -- uncomment the following line.
          --"--outdir out",
        },
        forwardSearchAfter = true,
        onSave = true,
      },
      forwardSearch = {
        executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
        args = { "-g", "%l", "%p", "%f" },
        onSave = true,
      },
      chktex = {
        onOpenAndSave = true, -- extra lints
        onEdit = true, -- give me lints, good and hard
      },
      diagnosticsDelay = 300,
      latexFormatter = 'latexindent',
      latexindent = {
        ['local'] = nil, -- local is a reserved keyword
        modifyLineBreaks = false,
      },
      bibtexFormatter = 'texlab',
      formatterLineLength = 120,
      -- OPTIONAL: The server needs to be configured
      -- to read the logs from the out directory as well.
      -- auxDirectory = "out",
    }
  },
}

