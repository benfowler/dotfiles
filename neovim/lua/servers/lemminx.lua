local lspconfig = require "lspconfig"

local M = {}

M.configure = function(on_attach, capabilities, debounce_msec)
    return {
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
        capabilities = capabilities,
        flags = { debounce_text_changes = debounce_msec },
    }
end

return M
