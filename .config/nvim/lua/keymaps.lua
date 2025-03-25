-- vim.keymap.set(mode, lhs, rhs, options)

-- Remap space as leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set('n', '<Space>', '<Nop>')

-- 邪魔なキーマップを無効化
vim.api.nvim_set_keymap('i', '<Nul>', '<Nop>', { noremap = true, silent = true })

-- Modes
--   normal_mode = 'n',
--   insert_mode = 'i',
--   visual_mode = 'v',
--   visual_block_mode = 'x',
--   term_mode = 't',
--   command_mode = 'c',

-- Normal mode
vim.keymap.set('n', 'x', '"_x')
vim.keymap.set('n', 'M', '%')
vim.keymap.set('n', 'Y', 'y$')
vim.keymap.set('n', 'b]', ':bnext<CR>')
vim.keymap.set('n', 'b[', ':bprevious<CR>')
vim.keymap.set('n', '<Tab>', ':bnext<CR>')
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>')
vim.keymap.set('n', 'P', ']P')
vim.keymap.set('n', 'p', ']p')

-- Terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
