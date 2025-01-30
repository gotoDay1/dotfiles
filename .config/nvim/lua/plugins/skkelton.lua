return {
    {
        "vim-skk/skkeleton",
        lazy = false,
        config = function()
            -- 辞書の設定
            vim.fn['skkeleton#config']({
                globalDictionaries = {
                    { '~/.skk/SKK-JISYO.L', 'euc-jp'},  
                },
            })

            -- Keymapの設定
            vim.api.nvim_set_keymap('i', '<C-k>', '<Plug>(skkeleton-toggle)', { noremap = false })
            vim.api.nvim_set_keymap('c', '<C-k>', '<Plug>(skkeleton-toggle)', { noremap = false })
            -- skkeletonのモードを取得して、ステータスラインに表示
            vim.o.statusline = vim.o.statusline .. '%{skkeleton#mode()}'
        end,
    },
}

