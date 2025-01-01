return {
    {
        "vim-skk/skkeleton",
        lazy = false,
        globalDictionaries = {
            "~/.skk/SKK-JISYO.L", 'euc-jp',
        },
        config = function()
            vim.api.nvim_set_keymap('i', '<C-k>', '<Plug>(skkeleton-enable)', { noremap = false })
            vim.api.nvim_set_keymap('c', '<C-k>', '<Plug>(skkeleton-enable)', { noremap = false })
        end,
    },
}

