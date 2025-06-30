Set-Alias -Name vim -Value nvim
Set-Alias -Name vi -Value nvim

# oh-my-posh
Set-Variable theme pure
oh-my-posh init pwsh --config $env:POSH_THEMES_PATH/$theme.omp.json | Invoke-Expression

# emacs 風ショートカットに
Import-Module PSReadline
Set-PSReadLineOption -EditMode Emacs


# Tab補完をzsh風に 
Set-PSReadLineOption -PredictionSource History
# その他補完機能
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadlineKeyHandler -Key Ctrl+p -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key Ctrl+n -Function HistorySearchForward


# Fzf
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

