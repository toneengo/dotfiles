require('spectre').setup()

local map = vim.api.nvim_set_keymap
map('n', '<leader>s', '<cmd>lua require("spectre").toggle()<CR>', { desc = "Toggle Spectre" })
