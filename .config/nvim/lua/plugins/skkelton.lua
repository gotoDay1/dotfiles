return {
    {
        "vim-skk/skkeleton",
        lazy = false,
        config = function()
            vim.fn['skkeleton#config']({
                globalDictionaries = {
                    { '~/.skk/SKK-JISYO.L', 'euc-jp'},  
                },
            })
            vim.api.nvim_set_keymap('i', '<C-k>', '<Plug>(skkeleton-enable)', { noremap = false })
            vim.api.nvim_set_keymap('c', '<C-k>', '<Plug>(skkeleton-enable)', { noremap = false })
        end,
    },
}

