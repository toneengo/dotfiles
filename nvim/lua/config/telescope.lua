local telescope = require 'telescope'

telescope.setup({
    extensions = {
        undo = {
        },
        fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
        },
        file_browser = {
        },
    },
})

local map = vim.api.nvim_set_keymap
local silent = { silent = true, noremap = true }
map('n', '<C-S-f>', ':Telescope current_buffer_fuzzy_find<CR>', silent)
map('n', '<C-p>', ':Telescope find_files<CR>', silent)
map('n', '<C-b>', ':Telescope buffers<CR>', silent)
map('n', '<C-g>', ':Telescope live_grep<CR>', silent)
map('n', '<C-S-p>', ':Telescope commands<CR>', silent)
map('n', '<C-S-a>', ':Telescope aerial<CR>', silent)
map('n', '<Leader>j', ':Telescope jumplist<CR>', silent)
map('n', '<Leader>r', ':Telescope lsp_references<CR>', silent)

telescope.load_extension 'undo'
telescope.load_extension 'ui-select'
--telescope.load_extension 'noice'
telescope.load_extension 'aerial'
