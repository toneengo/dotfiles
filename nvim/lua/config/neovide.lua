
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
end
