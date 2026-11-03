# ============================================================
#  PowerShell プロファイル
#  起動時間を計測したいとき: $env:PROFILE_TIMING = 1 にしてから pwsh を起動
#
#  起動を軽くするための工夫
#    - PSFzf はキーを初めて押したときに読み込む (遅延ロード)
#    - starship の初期化スクリプトはファイルにキャッシュする
#      (starship を更新すると自動で作り直す。手動で消すなら Clear-ProfileCache)
#    - PSReadLine は pwsh が自動で読み込むので Import-Module しない
# ============================================================

$__timing = [bool]$env:PROFILE_TIMING
$__sw = [System.Diagnostics.Stopwatch]::StartNew()
function __Mark($label) {
    if ($__timing) { Write-Host "$label : $($__sw.ElapsedMilliseconds)ms" }
}

$ProfileCacheDir = Join-Path $env:LOCALAPPDATA 'pwsh-profile-cache'

# ------------------------------------------------------------
#  エンコーディング（UTF-8）
# ------------------------------------------------------------
$OutputEncoding = [Console]::InputEncoding = [Console]::OutputEncoding = [Text.UTF8Encoding]::new($false)

$env:DISPLAY = "localhost:0.0"
__Mark "encoding"

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
__Mark "PSReadLine"

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
#  fzf（PSFzf を遅延ロード）
#  Ctrl+r / Ctrl+. を初めて押したときに PSFzf を読み込み、
#  以降は PSFzf 自身のキーバインドに置き換わる
# ------------------------------------------------------------
function __Import-PSFzf {
    if (-not (Get-Module PSFzf)) {
        Import-Module PSFzf
        Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+.' -PSReadlineChordReverseHistory 'Ctrl+r'
    }
}
Set-PSReadLineKeyHandler -Chord 'Ctrl+r' -Description 'fzf history (lazy)' -ScriptBlock {
    __Import-PSFzf
    Invoke-FzfPsReadlineHandlerHistory
}
Set-PSReadLineKeyHandler -Chord 'Ctrl+.' -Description 'fzf provider (lazy)' -ScriptBlock {
    __Import-PSFzf
    Invoke-FzfPsReadlineHandlerProvider
}
__Mark "PSFzf (lazy)"

# ------------------------------------------------------------
#  starship（プロンプト）
#  `starship init powershell` は毎回 starship を 2 回起動するので、
#  生成されるスクリプトをキャッシュして読み込む
# ------------------------------------------------------------
$__starship = Get-Command starship -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
if ($__starship) {
    $__starshipCache = Join-Path $ProfileCacheDir 'starship-init.ps1'
    $__cacheItem = Get-Item $__starshipCache -ErrorAction SilentlyContinue
    if (-not $__cacheItem -or $__cacheItem.LastWriteTime -lt (Get-Item $__starship.Source).LastWriteTime) {
        New-Item -ItemType Directory -Force $ProfileCacheDir | Out-Null
        & $__starship.Source init powershell --print-full-init | Set-Content -Path $__starshipCache -Encoding utf8
    }
    . $__starshipCache
}
__Mark "starship"

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

# プロファイルのキャッシュを消す（次回起動時に作り直される）
function Clear-ProfileCache {
    Remove-Item -Recurse -Force $ProfileCacheDir -ErrorAction SilentlyContinue
}

Remove-Variable __starship, __starshipCache, __cacheItem -ErrorAction SilentlyContinue
__Mark "done"
