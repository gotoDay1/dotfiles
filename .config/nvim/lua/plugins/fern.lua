return {
    {
        "lambdalisue/fern.vim",
        lazy = false,
        keys = {
            {
                "<C-a>",
                ":Fern %:h -drawer -toggle -reveal=% -width=45 <CR>",
                silent = true,
                desc = "Toggle Fern file explorer"
            }
        }
        -- Vimscriptベースのプラグインなので、optsではなくkeysを使用
    }
}
