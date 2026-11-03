-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Windows では :terminal / ターミナル系プラグインのシェルを PowerShell 7 (pwsh) にする
if vim.fn.has("win32") == 1 then
  LazyVim.terminal.setup("pwsh") -- pwsh が無ければ powershell にフォールバック
end
