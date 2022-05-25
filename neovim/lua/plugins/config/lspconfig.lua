-- NVIM 0.6+ NATIVE LSP SUPPORT

-- QUICKSTART:
--
-- LSP_SERVER_INSTALLATION: how to get your language servers going
--
--   :LspInstallInfo
--   :checkhealth lspconfig       " is the LSP configuration valid?
--
-- TROUBLESHOOTING: what if nothing happens?
--
--   :LspInfo
--
-- DEBUGGING: read the following:
--
--   https://github.com/neovim/nvim-lspconfig/blob/master/README.md#debugging
--

vim.lsp.set_log_level "debug"

local has_lspconfig, lspconfig = pcall(require, "lspconfig")
local has_lsp_installer, lsp_installer = pcall(require, "nvim-lsp-installer")
if not (has_lspconfig or has_lsp_installer) then
    return
end

local lsp_status_present, lsp_status = pcall(require, "lsp-status") -- get LSP diagnostics updates
if lsp_status_present then
    lsp_status.register_progress()
end

local lsp_icons = require("utils").diagnostic_icons.filled

local debounce_changes_msec = 150 -- msec

-- Passed to each language server on startup to configure each buffer for LSP
local function on_attach(client, bufnr)
    -- On-attach hooks
    if lsp_status_present then
        lsp_status.on_attach(client) --  required for lsp-status to get diagnostic events?
    end

    -- Options
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Set up keymappings for this buffer only
    require("mappings").lsp(bufnr, client.server_capabilities)

    -- CodeLens
    if client.server_capabilities.code_lens == true then
        vim.api.nvim_command [[autocmd CursorHold,CursorHoldI,InsertLeave <buffer> lua vim.lsp.codelens.refresh()]]
    end

    -- Extra setup, which depends on the final resolved set of capabilities
    -- provided by the language server, like identifier read/write highlighting.

    -- stylua: ignore
    if client.server_capabilities.document_highlight == true then
        vim.api.nvim_exec(
            [[
            augroup lsp_document_highlight
            autocmd! * <buffer>
            autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
            ]],
            false
        )
    end
end

-- Stock client capabilities...
local client_caps = vim.lsp.protocol.make_client_capabilities()

-- CMP
local has_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if has_cmp_nvim_lsp then
    client_caps = cmp_nvim_lsp.update_capabilities(client_caps)
end

-- lsp-status, to report LSP diagnostics to other plugins
if lsp_status_present then
    client_caps = vim.tbl_extend("force", client_caps, lsp_status.capabilities)
end

-- ... plus some extra one-offs we want to enable...
client_caps.textDocument.completion.completionItem.snippetSupport = true

-- Configure each installed LSP server with an override configuration, or some
-- sensible fallback defaults.

local servers = {
    "bashls",
    "clangd",
    "gopls",
    "jsonls",
    "jdtls",
    "lemminx",
    "metals",
    "pyright",
    "sumneko_lua",
    "texlab",
    "vimls",
    "yamlls"
}

local default_server_opts = {
    on_attach = on_attach,
    capabilities = client_caps,
    root_dir = vim.loop.cwd,
    flags = { debounce_text_changes = debounce_changes_msec },
}

lsp_installer.setup {
    automatic_installation = true,
    on_server_ready = function(server)
        put(server.name)
        local opts_present, opts = pcall(require, "servers." .. server.name)
        if opts_present then
            local config = opts.configure(on_attach, client_caps, debounce_changes_msec)
            server:setup(config)
        else
            server:setup(default_server_opts)
        end
    end,
}

for _, server in ipairs(servers) do
    local has_server_config, server_config = pcall(require, "servers." .. server)
    if has_server_config then
        lspconfig[server].setup(server_config.configure(on_attach, client_caps, debounce_changes_msec))
    else
        lspconfig[server].setup {}
    end
end

-- Loopback language server ('null-ls') is used to hook into LSP via Lua.
-- Used for linting, formatting, code actions, hovers, etc.
--
-- NOTE: null-ls isn't configured via lsp-config.  Must be done separately.

local null_ls = require "null-ls"
local null_ls_opts = require "servers.null-ls"
local null_ls_config = null_ls_opts.configure(on_attach, client_caps, debounce_changes_msec)

null_ls.setup(null_ls_config)

-- Customise appearance of diagnostics, symbols (gutter), virtual text

local function lspSymbol(key, icon, sign_name)
    vim.fn.sign_define(sign_name, {
        text = icon,
        texthl = "DiagnosticSign" .. key,
        linehl = nil,
        numhl = "DiagnosticLineNr" .. key,
    })
end

-- (Neovim 6.0 nightlies onwards (26th Sep 2021))
lspSymbol("Error", lsp_icons.error, "DiagnosticSignError")
lspSymbol("Warn", lsp_icons.warn, "DiagnosticSignWarn")
lspSymbol("Info", lsp_icons.info, "DiagnosticSignInfo")
lspSymbol("Hint", lsp_icons.hint, "DiagnosticSignHint")

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
        prefix = "",
        spacing = 6,
    },
    signs = true,
    severity_sort = true,
    underline = true,
    update_in_insert = false,
})

-- Popups get frames with rounded corners
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

local lspconfig_win = require "lspconfig.ui.windows"
local lspconfig_win_default_opts = lspconfig_win.default_opts

lspconfig_win.default_opts = function(options)
    local opts = lspconfig_win_default_opts(options)
    opts.border = "rounded"
    return opts
end
