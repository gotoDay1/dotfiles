vim.lsp.config("pylsp"{
  settings = {
    pylsp = {
      plugins = {
        jedi = {
          -- 仮想環境（venv）のルートディレクトリを指定
          environment = "./.venv/bin/python",
        },
      },
    },
  },
})
