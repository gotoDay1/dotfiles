return {
    {
        "neoclide/coc.nvim",
        branch = "release",
        lazy = false,

        config = function()
            local keyset = vim.keymap.set
            -- Autocomplete
            function _G.check_back_space()
                local col = vim.fn.col('.') - 1
                return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
            end
            
            local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
            keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
            keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

            keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

            -- Use <c-j> to trigger snippets
            keyset("i", "<c-l>", "<Plug>(coc-snippets-expand-jump)")
            -- Use <c-space> to trigger completionk
            keyset("i", "<c-h>", "coc#refresh()", {silent = true, expr = true})

            -- Use K to show documentation in preview window
            function _G.show_docs(key)
                local cw = vim.fn.expand('<cword>')
                if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
                    vim.api.nvim_command('h ' .. cw)
                elseif vim.api.nvim_eval('coc#rpc#ready()') then
                    vim.fn.CocActionAsync('doHover')
                else
                    vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
                end
            end
            keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})

			-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
            local cocGroup = vim.api.nvim_create_augroup("CocGroup", {clear = true})

			vim.api.nvim_create_autocmd("CursorHold", {
				group = "CocGroup",
				command = "silent call CocActionAsync('highlight')",
				desc = "Highlight symbol under cursor on CursorHold"
			})
        end,
    },
}
