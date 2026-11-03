vim.lsp.config("pyright", {
  settings = {
    python = {
      pythonPath = "./.venv/bin/python", -- プロジェクトごとのパス
    }
  }
})
