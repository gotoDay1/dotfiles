# ============================================================
#  PowerShell プロファイル
#  起動時間を計測したいとき: $env:PROFILE_TIMING = 1 にしてから pwsh を起動
# ============================================================

$__timing = [bool]$env:PROFILE_TIMING
$__sw = [System.Diagnostics.Stopwatch]::StartNew()
function __Mark($label) {
    if ($__timing) { Write-Host "$label : $($__sw.ElapsedMilliseconds)ms" }
}

# ------------------------------------------------------------
#  エンコーディング（UTF-8）
#  ※ chcp 65001 は下の設定と役割が重なるため削除
# ------------------------------------------------------------
$OutputEncoding = [Console]::InputEncoding = [Console]::OutputEncoding = [Text.UTF8Encoding]::new($false)
__Mark "encoding"

$env:DISPLAY = "localhost:0.0"

# ------------------------------------------------------------
#  alias
# ------------------------------------------------------------
Set-Alias -Name vim -Value nvim
Set-Alias -Name vi  -Value nvim

# 引数・オプションをすべて eza に渡す（ls -la なども使える）
function ls_eza { eza @args }
Set-Alias -Name ls -Value ls_eza -Option AllScope -Force

# ------------------------------------------------------------
#  PSReadLine
# ------------------------------------------------------------
Import-Module PSReadLine
__Mark "PSReadLine import"

# emacs 風ショートカット
Set-PSReadLineOption -EditMode Emacs

# 予測候補・補完（zsh 風）
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Key Tab       -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow   -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key Ctrl+p    -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key Ctrl+n    -Function HistorySearchForward

# ------------------------------------------------------------
#  vi / vim でもファイル名を補完する
#  （nvim 用の補完はエイリアス経由だと効かないことがあるため）
# ------------------------------------------------------------
Register-ArgumentCompleter -Native -CommandName vi, vim -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)
    Get-ChildItem -Path "$wordToComplete*" -Force -ErrorAction SilentlyContinue |
        ForEach-Object {
            $text = Resolve-Path -Relative $_.FullName
            if ($_.PSIsContainer) { $text += '\' }
            if ($text -match '\s') { $text = "'$text'" }
            [System.Management.Automation.CompletionResult]::new(
                $text, $_.Name, 'ProviderItem', $_.FullName)
        }
}

# ------------------------------------------------------------
#  fzf
# ------------------------------------------------------------
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+.' -PSReadlineChordReverseHistory 'Ctrl+r'
__Mark "PSFzf import"

# ------------------------------------------------------------
#  starship（プロンプト）※最後に読み込む
# ------------------------------------------------------------
Invoke-Expression (&starship init powershell)
__Mark "starship init"

# ------------------------------------------------------------
#  custom functions
# ------------------------------------------------------------
function tmpdir {
    $hash = ([Guid]::NewGuid().ToString("N")).Substring(0, 8)

    # カレントディレクトリ配下に作成（例: .\tmp_a1b2c3d4）
    $tempDirPath = Join-Path -Path . -ChildPath "tmp_$hash"

    # フォルダを作成
    $dir = New-Item -ItemType Directory -Path $tempDirPath -Force

    # パスを返す（スクリプトやパイプラインで利用可能にする）
    return $dir.FullName
}

__Mark "done"
