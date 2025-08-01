return {
    {
        "nvim-pack/nvim-spectre",
        dependencies = { 'nvim-lua/plenary.nvim', },
        config = function ()
            require('config.spectre');
        end,
    },
    {
        'nvim-tree/nvim-web-devicons'
    },
    {
        'vim-airline/vim-airline',
        dependencies = { 'vim-airline/vim-airline-themes', },
        init = function()
            vim.g.airline_powerline_fonts = 1
            vim.g['airline#extensions#tabline#enabled'] = 1
            vim.g.airline_theme = 'catppuccin'
        end,
    },
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        priority = 1000,
        config = function()
            require 'config.catppuccin'
        end,
    },
    {
        'lervag/vimtex',
    },
    {
        'nvim-lua/plenary.nvim',
    },
    {
        'BurntSushi/ripgrep',
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function ()
            require 'config.treesitter'
        end,
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = {
            'nvim-telescope/telescope-file-browser.nvim',
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-ui-select.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                 build = 'make'
            },
            'debugloop/telescope-undo.nvim',
        },
        config = function()
            require 'config.telescope'
        end,
    },
    {
        'stevearc/aerial.nvim',
        opts = {
            backends = { 'lsp', 'treesitter', 'markdown', 'man' },
            on_attach = function(bufnr)
                vim.keymap.set('n', '[[', '<cmd>AerialPrev<CR>', { buffer = bufnr })
                vim.keymap.set('n', ']]', '<cmd>AerialNext<CR>', { buffer = bufnr })
            end,
        },
        cmd = { 'AerialOpen', 'AerialToggle' },
    },
    {
      'saghen/blink.cmp',
      -- optional: provides snippets for the snippet source
      dependencies = { 'rafamadriz/friendly-snippets' },

      -- use a release tag to download pre-built binaries
      version = '1.*',
      -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
      -- build = 'cargo build --release',
      -- If you use nix, you can build from source using latest nightly rust with:
      -- build = 'nix run .#build-plugin',

      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = { preset = 'enter' },

        appearance = {
          -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          -- Adjusts spacing to ensure icons are aligned
          nerd_font_variant = 'mono'
        },

        -- (Default) Only show the documentation popup when manually triggered
        completion = { documentation = { auto_show = false } },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
        },

        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = "prefer_rust_with_warning" }
      },
      opts_extend = { "sources.default" }
    },
    {
        'neovim/nvim-lspconfig',
        lazy = false,

        dependencies = {
        },

        config = function()
            require 'config.lsp'
        end,
    }
}
