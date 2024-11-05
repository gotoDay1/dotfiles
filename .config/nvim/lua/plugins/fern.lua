return{
    {
        "lambdalisue/fern.vim",
        lazy = false,
        config = function()
            vim.keymap.set("n", "<C-a>", ":Fern %:hr -reveal=%<CR>", {silent = true})
        end,
    },
}
