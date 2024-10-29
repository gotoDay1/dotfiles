return{
    {
        "lambdalisue/fern.vim",
        event = "VimEnter",
        config = function()
            vim.keymap.set("n", "<C-a>", ":Fern %:hr -reveal=%<CR>", {silent = true})
        end,
    },
}
