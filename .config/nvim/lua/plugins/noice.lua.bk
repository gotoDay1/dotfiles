return {
    {
      "folke/noice.nvim",
      event = "VeryLazy",
      opts = {
          views = {
              cmdline_popup = {
                position = {
                  row = 20,
                  col = "50%",
                },
                size = {
                  width = 60,
                  height = "auto",
                },
              },
              popupmenu = {
                relative = "editor",
                position = {
                  row = 23,
                  col = "50%",
                },
                size = {
                  width = 60,
                  height = 15,
                },
                border = {
                  style = "rounded",
                  padding = { 0, 1 },
                },
                win_options = {
                  winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
                },
              },
        },
        messages = {
            view = 'notify',
            view_error = 'messages',
            view_warning = 'mini',
        },
      },
      dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "MunifTanjim/nui.nvim",
        -- OPTIONAL:
        --   `nvim-notify` is only needed, if you want to use the notification view.
        --   If not available, we use `mini` as the fallback
        "rcarriga/nvim-notify",
        }
    }
}
