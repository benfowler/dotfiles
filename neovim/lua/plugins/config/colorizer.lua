local M = { }

M.config = function()
    require("colorizer").setup({
        "*";
        css = { css = true; };
        html = { css = true; };
    }, {
        RRGGBB = true;
        RGB = false;
        names = false;
    })

    vim.cmd "ColorizerReloadAllBuffers"
end

return M

