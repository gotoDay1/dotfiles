Set-Alias -Name vim -Value nvim
Set-Alias -Name vi -Value nvim

oh-my-posh init pwsh --config $env:POSH_THEMES_PATH/pure.omp.json | Invoke-Expression

# emacs 風ショートカットに
Import-Module PSReadline
Set-PSReadLineOption -EditMode Emacs

Set-PSReadLineOption -PredictionSource History

# Tab補完をzsh風に 
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadlineKeyHandler -Key Ctrl+p -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key Ctrl+n -Function HistorySearchForward



# Fzf
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

