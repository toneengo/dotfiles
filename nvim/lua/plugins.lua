return {
    --[[
    {
        "karb94/neoscroll.nvim",
        config = function ()
            require('config.neoscroll')
        end,
    },
    ]]
    {
        "kmonad/kmonad-vim"
    },
    {
        "nvim-pack/nvim-spectre",
        dependencies = { 'nvim-lua/plenary.nvim', },
        config = function ()
            require('config.spectre');
        end,
    },
    {
        "declancm/cinnamon.nvim",
        version = "*",
        config = function ()
            require('config.cinnamon');
        end,
    },
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
        md = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
        },
        keys = {
            { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
            { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
            { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
            { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
            { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
        },
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
        'nvim-neo-tree/neo-tree.nvim',
        config = function()
            require 'config.neotree'
        end,
    },
    {
        'MunifTanjim/nui.nvim',
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
                 build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release'
            },
            'debugloop/telescope-undo.nvim',
        },
        config = function()
            require 'config.telescope'
        end,
    },
    {
        'akinsho/toggleterm.nvim',
        version = '*',
        opts = { open_mapping = [[<c-\>]], direction = 'float' },
        keys = [[<c-\>]],
    },
    {
        'Civitasv/cmake-tools.nvim',
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

    --[[
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
          -- add any options here
        },
        dependencies = {
          -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
          "MunifTanjim/nui.nvim",
          -- OPTIONAL:
          --   `nvim-notify` is only needed, if you want to use the notification view.
          --   If not available, we use `mini` as the fallback
          -- {
          --     "rcarriga/nvim-notify",
          --     config = function()
          --         require("notify").setup({
          --             background_colour = "#181825"
          --         })
          --     end,
          --  },
        },
        config = function()
            require 'config.noice'
        end,
    },
    {
        'folke/lazydev.nvim',
        ft = "lua",
        opts = {
            library = {
                "luvit-meta/library",
            },
        },
        config = function()
            require 'config.lazydev'
        end,
    },
    {
        'elkowar/yuck.vim',
    },
    
    --]]
    {
        'neovim/nvim-lspconfig',
        lazy = false,
        dependencies = {
            -- main one
            { "ms-jpq/coq_nvim", branch = "coq" },

            -- 9000+ Snippets
            { "ms-jpq/coq.artifacts", branch = "artifacts" },

            -- lua & third party sources -- See https://github.com/ms-jpq/coq.thirdparty
            -- Need to **configure separately**
            { 'ms-jpq/coq.thirdparty', branch = "3p" }
            -- - shell repl
            -- - nvim lua api
            -- - scientific calculator
            -- - comment banner
            -- - etc
        },

        init = function()
            vim.g.coq_settings = {
                auto_start = true,
            }
        end,

        config = function()
            require 'config.lsp'
        end,
    },
    --[[
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
          'hrsh7th/cmp-buffer',
          'hrsh7th/cmp-nvim-lsp',
          'hrsh7th/cmp-nvim-lsp-signature-help',
          'hrsh7th/cmp-path',
          'hrsh7th/cmp-nvim-lua',
          'lukas-reineke/cmp-under-comparator',
          'hrsh7th/cmp-cmdline',
          'hrsh7th/cmp-nvim-lsp-document-symbol',
          'hrsh7th/cmp-vsnip',
          'hrsh7th/vim-vsnip',
        },
        init = function()
          require 'config.cmp'
        end,
        event = 'InsertEnter',
    },
    --]]
}
