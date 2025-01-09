return{
    {
        "lambdalisue/fern.vim",
        lazy = false,
        config = function()
            vim.keymap.set("n", "<C-a>", ":Fern %:h -drawer -toggle -reveal=% -width=45 <CR>", {silent = true})
        end,
    },
}
