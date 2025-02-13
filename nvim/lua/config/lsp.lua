local lsp = require('lspconfig')
local coq = require "coq"

lsp.clangd.setup(coq.lsp_ensure_capabilities())
lsp.clangd.setup({
    cmd = {
        'clangd',
        '--background-index',
        '--clang-tidy',
        '--completion-style=bundled',
        '--header-insertion=iwyu',
        '--pch-storage=memory',
        '--malloc-trim',
        '--all-scopes-completion',
        '--enable-config',
        '-j=8',
    },
})

lsp.rust_analyzer.setup{
  settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        enable = false;
      }
    }
  }
}

--lsp.ccls.setup{}
lsp.ts_ls.setup{}
lsp.lua_ls.setup{}

vim.keymap.set("n", "]g", vim.diagnostic.goto_next)
vim.keymap.set("n", "[g", vim.diagnostic.goto_prev)

--[[
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = false,
})

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
  callback = function ()
    vim.diagnostic.open_float(nil, {focus=false})
  end
})
-]]

vim.keymap.set("n", "gq", vim.lsp.buf.hover)
