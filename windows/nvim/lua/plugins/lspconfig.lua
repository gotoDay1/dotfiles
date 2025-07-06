return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local on_attach = function(client, bufnr)
        local bufmap = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        bufmap("n", "gd", vim.lsp.buf.definition, "Go to Definition")
        bufmap("n", "K", vim.lsp.buf.hover, "Hover Documentation")
        bufmap("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
        bufmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
        bufmap("n", "[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
        bufmap("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
        bufmap("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
      end

      local servers = { "pyright", "ts_ls" }
      for _, server in ipairs(servers) do
        lspconfig[server].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end
    end,
  },
}
