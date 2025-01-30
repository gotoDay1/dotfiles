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
                eggLikeNewline = true,
            })
            -- lで小文字を入力できるようにする
            vim.fn['skkeleton#register_kanatable']("rom", { 
                l = false,
                ['la'] = {'ぁ',''},
                ['li'] = {'ぃ',''},
                ['lu'] = {'ぅ',''},
                ['le'] = {'ぇ',''},
                ['lo'] = {'ぉ',''},
                ['lya'] = {'ゃ',''},
                ['lyu'] = {'ゅ',''},
                ['lyo'] = {'ょ',''},
                ['lyu'] = {'ゅ',''},
                ['lyo'] = {'ょ',''},
                ['ltsu'] = {'っ',''},
                ['ltu'] = {'っ',''},
                [','] = {'，',''},
                ['.']= {'．',''}
            })
            -- Keymapの設定
            vim.api.nvim_set_keymap('i', '<C-k>', '<Plug>(skkeleton-toggle)', { noremap = false })
            vim.api.nvim_set_keymap('c', '<C-k>', '<Plug>(skkeleton-toggle)', { noremap = false })
            -- skkeletonのモードを取得して、ステータスラインに表示
            vim.o.statusline = vim.o.statusline .. '%{skkeleton#mode()}'
        end,
    },
}

