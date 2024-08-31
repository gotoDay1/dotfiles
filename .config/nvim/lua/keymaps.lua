-- vim.keymap.set(mode, lhs, rhs, options)

-- Remap space as leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 邪魔なキーマップを無効化
vim.api.nvim_set_keymap('i', '<Nul>', '<Nop>', { noremap = true, silent = true })

-- Modes
--   normal_mode = 'n',
--   insert_mode = 'i',
--   visual_mode = 'v',
--   visual_block_mode = 'x',
--   term_mode = 't',
--   command_mode = 'c',

