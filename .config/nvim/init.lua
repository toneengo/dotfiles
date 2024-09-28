-- Load plugins using packer.nvim
require('packer').startup(function()

  --theme
  use 'vim-airline/vim-airline'
  use 'vim-airline/vim-airline-themes'
  use 'folke/tokyonight.nvim'
  use { 'catppuccin/nvim', as = 'catppuccin' }
  use 'nvim-tree/nvim-web-devicons'

  use 'tpope/vim-fugitive'
  use 'tpope/vim-surround'
  use 'lervag/vimtex'

  use 'nvim-lua/plenary.nvim'
  use 'nvim-neo-tree/neo-tree.nvim'
  use 'MunifTanjim/nui.nvim'

  use 'BurntSushi/ripgrep'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use 'nvim-telescope/telescope.nvim'
  use 'nvim-telescope/telescope-file-browser.nvim'

  use 'akinsho/toggleterm.nvim'
  use 'Civitasv/cmake-tools.nvim'
  use 'stevearc/oil.nvim'

  --filetype
  use 'elkowar/yuck.vim'
  
  --Lsp stuff
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'

end)

-- Airline settings
vim.g.airline_powerline_fonts = 1
vim.g['airline#extensions#tabline#enabled'] = 1
vim.g.airline_theme = 'catppuccin'

-- General settings
vim.o.number = true
vim.cmd('highlight LineNr ctermfg=darkgrey')

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.cmd('colorscheme catppuccin-mocha')

-- Key mappings
vim.api.nvim_set_keymap('n', '<C-e>', ':Neotree<CR>', { noremap = true, silent = true })

vim.keymap.set('n', '<C-f>', ':Telescope current_buffer_fuzzy_find<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-n>', ':Telescope fd<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-b>', ':Telescope buffers<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-g>', ':Telescope live_grep<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-CR>', ':Telescope grep_string<CR>', { noremap = true, silent = true })

-- Autocompletion settings
--vim.o.updatetime = 300

-- Neovide settings
vim.g.neovide_scroll_animation_far_lines = 1
vim.g.neovide_transparency = 0.9

-- GUI font settings
vim.o.guifont = 'MonaspiceXe Nerd Font Mono:h10'

guifontsize=10
guifont='MonaspiceXe Nerd Font Mono'

function adjustSize (delta)
    guifontsize = guifontsize + delta
    vim.o.guifont = guifont .. ':h' .. tostring(guifontsize)
end

if vim.g.neovide then
    vim.keymap.set('n', '<C-->', function() adjustSize(-1) end, { noremap = true, silent = true })
    vim.keymap.set('n', '<C-=>', function() adjustSize(1) end, { noremap = true, silent = true })
    vim.keymap.set('i', '<C-->', function() adjustSize(-1) end, { noremap = true, silent = true })
    vim.keymap.set('i', '<C-=>', function() adjustSize(1) end, { noremap = true, silent = true })
else
    vim.cmd('highlight Normal guibg=NONE ctermbg=NONE')
    vim.cmd('highlight NonText guibg=NONE ctermbg=NONE')

end

require("oil").setup()
require("toggleterm").setup()

local cmp = require'cmp'

cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
})

-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
--[[ cmp.setup.filetype('gitcommit', {
sources = cmp.config.sources({
  { name = 'git' },
}, {
  { name = 'buffer' },
})
})
require("cmp_git").setup() ]]-- 

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
mapping = cmp.mapping.preset.cmdline(),
sources = {
  { name = 'buffer' }
}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
mapping = cmp.mapping.preset.cmdline(),
sources = cmp.config.sources({
  { name = 'path' }
}, {
  { name = 'cmdline' }
}),
matching = { disallow_symbol_nonprefix_matching = false }
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')
lspconfig.ccls.setup({
    capabilities = capabilities
})

vim.keymap.set("n", "]g", vim.diagnostic.goto_next)
vim.keymap.set("n", "[g", vim.diagnostic.goto_prev)

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = false,
})

vim.o.updatetime = 250
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
  callback = function ()
    vim.diagnostic.open_float(nil, {focus=false})
  end
})
