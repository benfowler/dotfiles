-- NVIM 0.6+ NATIVE LSP SUPPORT

-- QUICKSTART:
--
-- :LspInstall python
--
-- LSP_SERVER_INSTALLATION: how to get your language servers going
--
-- :LspUpdate [dry]             " are any language servers running?
-- :checkhealth lspconfig       " is the LSP configuration valid?
--
-- CODE_LINTERS_INSTALLATION:
--
-- NOTE!!  The 'diagnostics' linter server lets us use lots of third-party
--         tools to lint and format our code, but there is NO SUPPORT for
--         installing them automatically.  If you're not seeing the error
--         messages you're expecting, read the 'diagnosticsls' configuration
--         section below to figure out what tools are missing or misconfigured.
--
-- TROUBLESHOOTING: what if nothing happens?
--
-- : LspInfo
--
-- Ensure that editor is open in a directory recognised by the LSP server
-- (See CONFIG.md).
--
-- This can be customized, e.g.:
--
-- local lspconfig = require'lspconfig'
-- lspconfig.gopls.setup{
--   root_dir = lspconfig.util.root_pattern('.git');
-- }
--
-- DEBUGGING: read the following:
--
--   https://github.com/neovim/nvim-lspconfig/blob/master/README.md#debugging
--

local has_lspconfig, lspconfig = pcall(require, "lspconfig")
local has_lsp_installer, lsp_installer = pcall(require, "nvim-lsp-installer")
if not (has_lspconfig or has_lsp_installer) then
    return
end

local lsp_status_present, lsp_status = pcall(require, "lsp-status") -- get LSP diagnostics updates
if lsp_status_present then
    lsp_status.register_progress()
end

local debounce_text_changes_msec = 150 -- msec

-- on_attach():
--
-- This callback is passed to each language server upon startup to configure
-- each buffer for LSP in turn.

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

    -- Mappings
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    local opts = { noremap = true, silent = true }

    buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>", opts)
    buf_set_keymap("n", "gk", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    buf_set_keymap("n", "gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    buf_set_keymap("n", "gt", "<Cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    buf_set_keymap("n", "gI", "<Cmd>lua vim.lsp.buf.incoming_calls()<CR>", opts)
    buf_set_keymap("n", "gO", " <Cmd>lua vim.lsp.buf.outgoing_calls()<CR>", opts)
    buf_set_keymap("n", "<Leader>gw", "<Cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
    buf_set_keymap("n", "<Leader>gW", "<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>", opts)
    buf_set_keymap("n", "<Leader>a", ":Telescope lsp_code_actions<CR>", opts)
    buf_set_keymap("n", "<Leader>A", "<Cmd>lua vim.lsp.codelens.run()<CR>", opts)
    buf_set_keymap("n", "<Leader>rn", "<Cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "<C-k>", '<Cmd>lua vim.diagnostic.goto_prev({float={border="rounded"}})<CR>', opts)
    buf_set_keymap("n", "<C-j>", '<Cmd>lua vim.diagnostic.goto_next({float={border="rounded"}})<CR>', opts)
    buf_set_keymap("n", "[d", '<Cmd>lua vim.diagnostic.goto_prev({float={border="rounded"}})<CR>', opts)
    buf_set_keymap("n", "]d", '<Cmd>lua vim.diagnostic.goto_next({float={border="rounded"}})<CR>', opts)
    buf_set_keymap("n", "<Leader>Wa", "<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
    buf_set_keymap("n", "<Leader>Wr", "<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
    buf_set_keymap("n", "<Leader>Wl", "<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_range_formatting == true then
        buf_set_keymap("n", "<Leader>f", "<Cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
        buf_set_keymap("v", "<Leader>f", "<Cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    elseif client.resolved_capabilities.document_formatting == true then
        buf_set_keymap("n", "<Leader>f", "<Cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    end

    -- CodeLens
    if client.resolved_capabilities.code_lens == true then
        vim.notify("CodeLens is enabled", "info", { title = "LSP"})
        vim.api.nvim_command [[autocmd CursorHold,CursorHoldI,InsertLeave <buffer> lua vim.lsp.codelens.refresh()]]
    end

    -- Extra setup, which depends on the final resolved set of capabilities
    -- provided by the language server, like identifier read/write highlighting.

    -- stylua: ignore
    if client.resolved_capabilities.document_highlight == true then
        vim.api.nvim_exec(
            [[
            augroup lsp_document_highlight
            autocmd! * <buffer>
            autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
            ]],
            false
        )
    end
end

--
-- Provide a way to enforce only a single running client at a time providing a
-- given resolved capability.
--
-- MOTIVATION: When doing formatting, use this to choose a formatter and
-- suppress the "Choose a language client:" menu.
--

-- Dictionary of resolved capabilities, to a map of LSP clients preferred for a
-- given file type.  When filtered through this function, only ONE client is
-- allowed to expose that capability.
local resolved_capability_filters = {
    ["document_formatting"] = { ["go"] = "go" }, -- diagnosticls not set up to fmt Lua, but says it can?
}

function resolve_resolved_cap_conflict(cap_to_filter, callback)
    local filetype = vim.bo.filetype
    local clients = vim.lsp.buf_get_clients(0)

    local filters = resolved_capability_filters[cap_to_filter]
    if filters == nil then
        callback() -- nothing else to
        return
    end

    local preferred_cap_client = filters[filetype]

    -- Count clients that offer document formatting.
    local num_formatting_clients = 0
    local preferred_cap_client_seen = false
    for _, client in pairs(clients) do
        if client.resolved_capabilities[cap_to_filter] == true then
            num_formatting_clients = num_formatting_clients + 1
            if client.name == preferred_cap_client then
                preferred_cap_client_seen = true
            end
        end
    end

    -- Now, disable excess/not-whitelisted LSP servers providing that capability

    if preferred_cap_client_seen then
        -- If the preferred client is running, suppress the others
        vim.notify(
            "Set server '" .. preferred_cap_client .. "' as sole provider of '" .. cap_to_filter .. "'",
            "warn",
            { title = "LSP" }
        )
        for _, client in pairs(clients) do
            if client.resolved_capabilities[cap_to_filter] == true then
                if client.name ~= preferred_cap_client then
                    client.resolved_capabilities[cap_to_filter] = false
                end
            end
        end
    else
        -- If not, just spare the first one, suppress the othes
        local saved_one = false
        for _, client in pairs(clients) do
            if client.resolved_capabilities[cap_to_filter] == true then
                if saved_one == false then
                    vim.notify(
                        "Randomly making server '" .. client.name .. "' sole provider of '" .. cap_to_filter .. "'",
                        "warn",
                        { title = "LSP" }
                    )
                    saved_one = true
                else
                    vim.notify(
                        "Server '" .. client.name .. "' prevented from providing '" .. cap_to_filter .. "'",
                        "warn",
                        { title = "LSP" }
                    )
                    client.resolved_capabilities[cap_to_filter] = false
                end
            end
        end
    end

    callback()
end

local client_caps = {}

-- Stock client capabilities...
client_caps = vim.tbl_extend("force", client_caps, vim.lsp.protocol.make_client_capabilities())

-- lsp-status, if loaded
if lsp_status_present then
    client_caps = vim.tbl_extend("force", client_caps, lsp_status.capabilities)
end

-- ... plus some additional one-offs we want to enable...
client_caps.textDocument.completion.completionItem.snippetSupport = true

-- With the "on_attach()" buffer configuration callback, and the 'capabilities'
-- object in hand, we are now ready to configure each language server.

local lsp_server_configs = {
    sumneko_lua = {
        settings = {
            Lua = {
                runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
                completion = { enable = true, callSnippet = "Both" },
                diagnostics = {
                    enable = true,
                    globals = { "vim", "describe" },
                    disable = { "lowercase-global" },
                },
                workspace = {
                    library = {
                        [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                        [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
                    },
                    maxPreload = 100000,
                    preloadFileSize = 10000,
                },
                telemetry = {
                    enable = false,
                },
            },
        },
        on_attach = on_attach,
        capabilities = client_caps,
        root_dir = vim.loop.cwd,
        flags = { debounce_text_changes = debounce_text_changes_msec },
    },
    texlab = {
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
                -- OPTIONAL: The server needs to be configured
                -- to read the logs from the out directory as well.
                -- auxDirectory = "out",
            },
        },
        on_attach = on_attach,
        capabilities = client_caps,
        root_dir = vim.loop.cwd,
        flags = { debounce_text_changes = debounce_text_changes_msec },
    },
    gopls = {
        cmd = { "gopls", "serve" },
        root_dir = function(fname)
            if has_lspconfig then
                local util = lspconfig.util
                return util.root_pattern("go.mod", ".git")(fname) or util.path.dirname(fname)
            end
        end,
        settings = {
            gopls = {
                analyses = {
                    unusedparams = true,
                    unreachable = false,
                },
                codelenses = {
                    generate = true, -- show the `go generate` lens.
                    gc_details = true, --  // Show a code lens toggling the display of gc's choices.
                    test = true,
                    tidy = true,
                },
                usePlaceholders = true,
                completeUnimported = true,
                staticcheck = true,
                matcher = "Fuzzy",
            },
        },
        flags = { allow_incremental_sync = true, debounce_text_changes = 500 },
    },
    clangd = {
        handlers = lsp_status.extensions.clangd.setup(),
        init_options = {
            clangdFileStatus = true,
        },
        on_attach = on_attach,
        capabilities = client_caps,
        flags = { debounce_text_changes = debounce_text_changes_msec },
    },
    lemminx = {
        cmd = {
            "java",
            "-cp",
            "/Users/bfowler/Library/LanguageServers/xml/lib/*",
            "-Djava.util.logging.config.file=/Users/bfowler/Library/LanguageServers/xml/logging.properties",
            -- "-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=127.0.0.1:5005",
            "org.eclipse.lemminx.XMLServerLauncher",
        },
        filetypes = { "xml", "pom", "xsd", "xsl", "svg" },
        root_dir = function(fname)
            return lspconfig.util.find_git_ancestor(fname) or vim.loop.os_homedir()
        end,
        on_attach = on_attach,
        capabilities = client_caps,
        flags = { debounce_text_changes = debounce_text_changes_msec },
    },
    diagnosticls = {
        filetypes = {
            "css",
            "go",
            "javascript",
            "javascriptreact",
            "lua",
            "markdown",
            "python",
            "scss",
            "sh",
            "typescript",
            "typescriptreact",
        },
        init_options = {
            linters = {
                eslint = {
                    command = "eslint",
                    rootPatterns = { ".git" },
                    debounce = 100,
                    args = { "--stdin", "--stdin-filename", "%filepath", "--format", "json" },
                    sourceName = "eslint",
                    parseJson = {
                        errorsRoot = "[0].messages",
                        line = "line",
                        column = "column",
                        endLine = "endLine",
                        endColumn = "endColumn",
                        message = "[eslint] ${message} [${ruleId}]",
                        security = "severity",
                    },
                    securities = {
                        [2] = "error",
                        [1] = "warning",
                    },
                },
                markdownlint = {
                    command = "markdownlint",
                    rootPatterns = { ".git" },
                    isStderr = true,
                    debounce = 100,
                    args = { "--stdin" },
                    offsetLine = 0,
                    offsetColumn = 0,
                    sourceName = "markdownlint",
                    securities = {
                        undefined = "hint",
                    },
                    formatLines = 1,
                    formatPattern = {
                        "^.*?:\\s?(\\d+)(:(\\d+)?)?\\s(MD\\d{3}\\/[A-Za-z0-9-/]+)\\s(.*)$",
                        {
                            line = 1,
                            column = 3,
                            message = { "[", 4, "]: ", 5 },
                        },
                    },
                },
                mypy = {
                    sourceName = "mypy",
                    command = "mypy",
                    args = {
                        "--no-color-output",
                        "--no-error-summary",
                        "--show-column-numbers",
                        "--follow-imports=silent",
                        "%file",
                    },
                    formatPattern = {
                        "^.*:(\\d+?):(\\d+?): ([a-z]+?): (.*)$",
                        {
                            line = 1,
                            column = 2,
                            security = 3,
                            message = 4,
                        },
                    },
                    securities = {
                        error = "error",
                    },
                },
                pylint = {
                    sourceName = "pylint",
                    args = {
                        "--output-format",
                        "text",
                        "--score",
                        "no",
                        "--msg-template",
                        [['{line}:{column}:{category}:{msg} ({msg_id}:{symbol})']],
                        "%file",
                    },
                    offsetColumn = 1,
                    formatLines = 1,
                    formatPattern = {
                        [[^(\d+?):(\d+?):([a-z]+?):(.*)$]],
                        { line = 1, column = 2, security = 3, message = { "[pylint] ", 4 } },
                    },
                    securities = {
                        informational = "hint",
                        refactor = "info",
                        convention = "info",
                        warning = "warning",
                        error = "error",
                        fatal = "error",
                    },
                    rootPatterns = { ".git", "pyproject.toml", "setup.py" },
                },
                shellcheck = {
                    sourceName = "shellcheck",
                    command = "shellcheck",
                    debounce = 100,
                    args = { "--format", "json1", "-" },
                    parseJson = {
                        errorsRoot = "comments",
                        sourceName = "file",
                        line = "line",
                        column = "column",
                        endLine = "endLine",
                        endColumn = "endColumn",
                        message = "[shellcheck] ${message} [SC${code}]",
                        security = "level",
                    },
                    securities = {
                        error = "error",
                        warning = "warning",
                        info = "info",
                        style = "hint",
                    },
                },
                luacheck = {
                    sourceName = "luacheck",
                    command = "luacheck",
                    debounce = 100,
                    args = { "--codes", "--no-color", "--quiet", "-" },
                    offsetLine = 0,
                    offsetColumn = 0,
                    formatLines = 1,
                    formatPattern = {
                        [[^.*:(\d+):(\d+):\s\(([W|E])\d+\)\s(.*)(\r|\n)*$]],
                        { line = 1, column = 2, security = 3, message = { "[luacheck] ", 4 } },
                    },
                    securities = { E = "error", W = "warning" },
                    rootPatterns = { ".luacheckrc" },
                },
                golangci_lint = {
                    sourceName = "golangci_lint",
                    command = "golangci-lint",
                    args = { "run", "--out-format", "json" },
                    debounce = 100,
                    parseJson = {
                        sourceNameFilter = true,
                        sourceName = "Pos.Filename",
                        errorsRoot = "Issues",
                        line = "Pos.Line",
                        column = "Pos.Column",
                        message = "[golangci_lint] ${Text} [${FromLinter}]",
                    },
                    rootPatterns = { ".git", "go.mod" },
                },
            },
            filetypes = {
                javascript = "eslint",
                javascriptreact = "eslint",
                typescript = "eslint",
                typescriptreact = "eslint",
                markdown = "markdownlint",
                sh = "shellcheck",
                lua = "luacheck",
                go = "golangci_lint",
            },
            formatters = {
                prettierEslint = {
                    command = "prettier-eslint",
                    args = { "--stdin" },
                    rootPatterns = { ".git" },
                },
                prettier = {
                    command = "prettier",
                    args = { "--stdin-filepath", "%filename" },
                },
                stylua = {
                    command = "stylua",
                    args = { "-s", "-" },
                },
                black = {
                    command = "black",
                    args = { "--quiet", "-" },
                    rootPatterns = {
                        ".git",
                        "pyproject.toml",
                        "setup.py",
                    },
                },
            },
            formatFiletypes = {
                css = "prettier",
                javascript = "prettierEslint",
                javascriptreact = "prettierEslint",
                json = "prettier",
                lua = "stylua",
                scss = "prettier",
                typescript = "prettierEslint",
                typescriptreact = "prettierEslint",
                python = "black",
            },
        },
        on_attach = on_attach,
        capabilities = client_caps,
        flags = { debounce_text_changes = debounce_text_changes_msec },
    },
}

-- Configure each installed LSP server with an override configuration (see above)
-- or some sensible fallback defaults.
local default_server_opts = {
    on_attach = on_attach,
    capabilities = client_caps,
    root_dir = vim.loop.cwd,
    flags = { debounce_text_changes = debounce_text_changes_msec },
}

lsp_installer.on_server_ready(function(server)
    local opts = lsp_server_configs[server.name]
    if opts ~= nil then
        server:setup(opts)
    else
        server:setup(default_server_opts)
    end
end)

local function lspSymbol(key, icon, sign_name)
    vim.fn.sign_define(sign_name, {
        text = icon,
        texthl = "DiagnosticSign" .. key,
        linehl = nil,
        numhl = "DiagnosticLineNr" .. key,
    })
end

-- (Neovim 5.0+)
lspSymbol("Error", "", "DiagnosticSignError")
lspSymbol("Warn", "", "DiagnosticSignWarn")
lspSymbol("Info", "", "DiagnosticSignInfo")
lspSymbol("Hint", "", "DiagnosticSignHint")

-- (Neovim 6.0 nightlies onwards (26th Sep 2021))
lspSymbol("Error", "", "LspDiagnosticsSignError")
lspSymbol("Warn", "", "LspDiagnosticsSignWarning")
lspSymbol("Info", "", "LspDiagnosticsSignInformation")
lspSymbol("Hint", "", "LspDiagnosticsSignHint")

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
        prefix = "", -- "«"
        spacing = 6,
    },
    signs = true,
    severity_sort = true,
    underline = true,
    -- set this to true if you want diagnostics to show in insert mode
    update_in_insert = true,
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

-- Suppress error messages from lang servers
vim.notify = function(msg, log_level)
    if msg:match "exit code" then
        return
    end
    if log_level == vim.log.levels.ERROR then
        vim.api.nvim_err_writeln(msg)
    else
        vim.api.nvim_echo({ { msg } }, true, {})
    end
end
