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

local present1, lspconfig = pcall(require, "lspconfig")
local present2, lspinstall = pcall(require, "lspinstall")
if not (present1 or present2) then
    return
end

local configs = require "lspconfig/configs"

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
    buf_set_keymap("n", "<F1>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    buf_set_keymap("n", "gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    buf_set_keymap("n", "gt", "<Cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    buf_set_keymap("n", "gI", "<Cmd>lua vim.lsp.buf.incoming_calls()<CR>", opts)
    buf_set_keymap("n", "gO", " <Cmd>lua vim.lsp.buf.outgoing_calls()<CR>", opts)
    buf_set_keymap("n", "<Leader>gw", "<Cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
    buf_set_keymap("n", "<Leader>gW", "<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>", opts)
    buf_set_keymap("n", "<Leader>a", ":Telescope lsp_code_actions<CR>", opts)
    buf_set_keymap("n", "<Leader>l", "<Cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
    buf_set_keymap("n", "<Leader>rn", "<Cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "<Leader>e", "<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
    buf_set_keymap("n", "<C-k>", "<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "<C-j>", "<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
    buf_set_keymap("n", "[d", "<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "]d", "<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
    buf_set_keymap("n", "<Leader>Wa", "<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
    buf_set_keymap("n", "<Leader>Wr", "<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
    buf_set_keymap("n", "<Leader>Wl", "<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_range_formatting then
        buf_set_keymap("n", "<Leader>f", "<Cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
        buf_set_keymap("v", "<Leader>f", "<Cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    elseif client.resolved_capabilities.document_formatting then
        buf_set_keymap("n", "<Leader>f", "<Cmd>lua resolve_resolved_cap_conflict('document_formatting', vim.lsp.buf.formatting)<CR>", opts)
    end

    -- Extra setup, which depends on the final resolved set of capabilities
    -- provided by the language server, like identifier read/write highlighting.

    -- stylua: ignore
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
            augroup lsp_document_highlight
            autocmd! * <buffer>
            autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
        ]], false)
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
    ["document_formatting"] = { ["go"] = "go" },   -- diagnosticls not set up to fmt Lua, but says it can?
}

function resolve_resolved_cap_conflict(cap_to_filter, callback)
    local filetype = vim.bo.filetype
    local clients = vim.lsp.buf_get_clients(0)

    local filters = resolved_capability_filters[cap_to_filter]
    if filters == nil then
        callback()    -- nothing else to
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
        print("[LSP]: NOTE: set server '" .. preferred_cap_client .. "' as sole provider of '" .. cap_to_filter .. "'")
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
                    print("[LSP]: WARNING: randomly making server '" .. client.name .. "' sole provider of '" .. cap_to_filter .. "'")
                    saved_one = true
                else
                    print("[LSP]: WARNING: server '" .. client.name .. "' prevented from providing '" .. cap_to_filter .. "'")
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
--
-- Most language servers are trivial to set up, but others, like the
-- Sumneko Lua Language Server, Lemminx XML, and the 'diagnostics' server
-- (an ALE-like linter language server), require a lot more work to set up.

-- TODO: *** EXAMPLE ONLY.  THIS FUNCTION DOES NOT GET CALLED. ***
-- TODO: Add clangd etc
local function configure_custom_installers()
    --     -- 1. get the default config from nvim-lspconfig
    --     local config = require("lspinstall/util").extract_config "bashls"
    --     -- 2. update the cmd. relative paths are allowed, lspinstall automatically adjusts
    --     the cmd and cmd_cwd for us!
    --     config.default_config.cmd[1] = "./node_modules/.bin/bash-language-server"
    --
    --     -- 3. extend the config with an install_script and (optionally) uninstall_script
    --     require("lspinstall/servers").bash = vim.tbl_extend("error", config, {
    --         -- lspinstall will automatically create/delete the install directory for every server
    --         install_script = [[
    --             ! test -f package.json && npm init -y --scope=lspinstall || true
    --             npm install bash-language-server@latest
    --         ]],
    --         uninstall_script = nil, -- can be omitted
    --     })
end

-- Set up LSP servers.  First initialize all servers installed via lsp-install.
-- Then, hack in a couple of extra servers that are not yet covered by
-- lsp-install.
--
-- TODO: write custom installers for clangd and lemminx
-- TODO: then, split out configuration for each plugin into separate Lua modules
--
local function setup_servers()
    lspinstall.setup()
    configure_custom_installers()
    local servers = lspinstall.installed_servers()

    for _, lang in pairs(servers) do
        if lang == "lua" then
            lspconfig[lang].setup {
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
            }
        elseif lang == "cpp" then -- clangd
            -- Special handling for lsp-status
            local status_handlers = configs[lang].handlers -- preserve existing
            if lsp_status_present then
                status_handlers = lsp_status.extensions.clangd.setup()
            end

            lspconfig[lang].setup {
                handlers = status_handlers,
                init_options = {
                    clangdFileStatus = true,
                },
                on_attach = on_attach,
                capabilities = client_caps,
                flags = { debounce_text_changes = debounce_text_changes_msec },
            }
        elseif lang == "diagnosticls" then -- diagnosticls (general linting language server)
            lspconfig[lang].setup {
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
                        shellcheck = {
                            command = "shellcheck",
                            debounce = 100,
                            args = { "--format", "json", "-" },
                            sourceName = "shellcheck",
                            parseJson = {
                                line = "line",
                                column = "column",
                                endLine = "endLine",
                                endColumn = "endColumn",
                                message = "${message} [${code}]",
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
                        python = "mypy",
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
                    },
                },
                on_attach = on_attach,
                capabilities = client_caps,
                flags = { debounce_text_changes = debounce_text_changes_msec },
            }
        else
            -- Everything else
            lspconfig[lang].setup {
                on_attach = on_attach,
                capabilities = client_caps,
                root_dir = vim.loop.cwd,
                flags = { debounce_text_changes = debounce_text_changes_msec },
            }
        end
    end

    -- Now set up language servers that are NOT managed using lsp-install.
    -- NOTE: this is a hack, and will go away, once I add custom installers to lsp-install (see above)
    -- -- Eclipse LemMinX (XML, Maven)

    -- stylua: ignore
    configs["lemminx_xml"] = {
        default_config = {
            cmd = {
                "java", "-cp", "/Users/bfowler/Library/LanguageServers/xml/lib/*",
                "-Djava.util.logging.config.file=/Users/bfowler/Library/LanguageServers/xml/logging.properties",
                -- "-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=127.0.0.1:5005",
                "org.eclipse.lemminx.XMLServerLauncher",
            },
            filetypes = { "xml", "pom", "xsd", "xsl", "svg" },
            root_dir = function(fname)
                return lspconfig.util.find_git_ancestor(fname) or vim.loop.os_homedir()
            end,
            settings = {},
        },
    }

    lspconfig["lemminx_xml"].setup {
        on_attach = on_attach,
        capabilities = client_caps,
        flags = { debounce_text_changes = debounce_text_changes_msec },
    }
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
lspinstall.post_install_hook = function()
    setup_servers() -- reload installed servers
    vim.cmd "bufdo e"
end

-- Replace the default LSP diagnostic symbols
local function lspSymbol(name, icon)
    vim.fn.sign_define("LspDiagnosticsSign" .. name, {
        text = icon,
        texthl = "LspDiagnostics" .. name,
        linehl = nil,
        numhl = "LspDiagnosticsLineNr" .. name,
    })
end

lspSymbol("Error", "")
lspSymbol("Warning", "")
lspSymbol("Information", "")
lspSymbol("Hint", "")

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
        prefix = "", -- "«"
        spacing = 6,
    },
    signs = true,
    underline = true,
    -- set this to true if you want diagnostics to show in insert mode
    update_in_insert = false,
})

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
