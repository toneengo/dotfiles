require('spectre').setup({
    live_update = true,
    default = {
       find = {
           cmd = "rg",
           options = {},
       },
       replace = {
            cmd = "oxi"
       }
    }
})

local map = vim.api.nvim_set_keymap
map('n', '<leader>s', '<cmd>lua require("spectre").toggle()<CR>', { desc = "Toggle Spectre" })
