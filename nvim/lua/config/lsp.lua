local lsp = require('lspconfig')
local capabilities = require('blink.cmp').get_lsp_capabilities()

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == "glsl_analyzer" then
            client.cancel_request = function() end
        end
    end,
})

lsp.clangd.setup({capabilities = capabilities})
lsp.rust_analyzer.setup({capabilities = capabilities})
lsp.glsl_analyzer.setup({capabilities = capabilities})
lsp.ts_ls.setup({capabilities = capabilities})
lsp.lua_ls.setup({capabilities = capabilities})

vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "gq", vim.lsp.buf.hover)
