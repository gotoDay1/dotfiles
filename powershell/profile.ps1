# ============================================================
#  PowerShell プロファイル
#  起動時間を計測したいとき: $env:PROFILE_TIMING = 1 にしてから pwsh を起動
#
#  起動を軽くするための工夫
#    - PSFzf はキーを初めて押したときに読み込む (遅延ロード)
#    - starship / zoxide の初期化スクリプトはファイルにキャッシュする
#      (starship を更新すると自動で作り直す。手動で消すなら Clear-ProfileCache)
#    - PSReadLine は pwsh が自動で読み込むので Import-Module しない
#
#  マシン固有の設定は ~\.pwsh_profile.local.ps1 に書く (git 管理外、最後に読み込む)
# ============================================================

$__timing = [bool]$env:PROFILE_TIMING
$__sw = [System.Diagnostics.Stopwatch]::StartNew()
function __Mark($label) {
    if ($__timing) { Write-Host "$label : $($__sw.ElapsedMilliseconds)ms" }
}

$ProfileCacheDir = Join-Path $env:LOCALAPPDATA 'pwsh-profile-cache'
# このファイルは $PROFILE から dot-source されるので、$PSScriptRoot はリポジトリの powershell\
$DotfilesDir = Split-Path -Parent $PSScriptRoot

# 初期化スクリプトをキャッシュしてそのパスを返す (コマンドが無ければ $null)。
# コマンド本体が更新されたときだけ作り直す。
# プロファイルのスコープで読み込むため、呼び出し側で dot-source する:
#   $c = __Get-InitCache starship init powershell '--print-full-init'; if ($c) { . $c }
function __Get-InitCache([string]$Command) {
    $exe = Get-Command $Command -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $exe) { return $null }
    $cache = Join-Path $ProfileCacheDir "$Command-init.ps1"
    $item = Get-Item $cache -ErrorAction SilentlyContinue
    if (-not $item -or $item.Length -eq 0 -or $item.LastWriteTime -lt (Get-Item $exe.Source).LastWriteTime) {
        New-Item -ItemType Directory -Force $ProfileCacheDir | Out-Null
        & $exe.Source @args | Set-Content -Path $cache -Encoding utf8
    }
    return $cache
}

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

# lf: 閉じたときのディレクトリへ移動する（公式の lfcd.ps1 と同じ仕組み）
function lf { lf.exe -print-last-dir @args | Set-Location }

# lf などが使うエディタ
$env:EDITOR = 'nvim'
$env:VISUAL = 'nvim'

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
#  設定は zsh と共通の .config\starship.toml をリポジトリから直接読む
#  `starship init powershell` は毎回 starship を 2 回起動するので、
#  生成されるスクリプトをキャッシュして読み込む
# ------------------------------------------------------------
$env:STARSHIP_CONFIG = Join-Path $DotfilesDir '.config\starship.toml'
$__cache = __Get-InitCache starship init powershell '--print-full-init'
if ($__cache) { . $__cache }
__Mark "starship"

# ------------------------------------------------------------
#  zoxide（z <キーワード> でよく使うディレクトリへ移動）
#  starship の後に読み込む（プロンプトのフックに追加するため）
# ------------------------------------------------------------
$__cache = __Get-InitCache zoxide init powershell
if ($__cache) { . $__cache }
__Mark "zoxide"

# ------------------------------------------------------------
#  Secrets (Bitwarden CLI)
#  API キーなどは Bitwarden のセキュアメモに KEY=VALUE 形式で保存しておき、
#  必要なときに bwenv で環境変数に読み込む。
#    bwenv          アイテム "dotfiles-env" ($env:BW_ENV_ITEM で変更可) を読み込む
#    bwenv <name>   指定したアイテムを読み込む
#    bwlock         環境変数を消して Bitwarden をロックする
#  初回だけ bw login が必要。ロックされていればマスターパスワードを聞かれる。
# ------------------------------------------------------------
if (-not $env:BW_ENV_ITEM) { $env:BW_ENV_ITEM = 'dotfiles-env' }
$global:BwEnvKeys = @()

function bwenv([string]$Item = $env:BW_ENV_ITEM) {
    if (-not (Get-Command bw -ErrorAction SilentlyContinue)) {
        Write-Error 'bwenv: bw (Bitwarden CLI) が見つかりません'; return
    }

    $status = (bw status 2>$null | ConvertFrom-Json).status
    if ($status -eq 'unauthenticated') {
        Write-Error 'bwenv: 先に bw login を実行してください'; return
    }
    if ($status -ne 'unlocked') {
        $session = bw unlock --raw
        if ($LASTEXITCODE -ne 0 -or -not $session) { return }
        $env:BW_SESSION = $session
    }

    bw sync *> $null
    $notes = bw get notes $Item
    if ($LASTEXITCODE -ne 0) { return }

    $count = 0
    foreach ($line in ($notes -split "`r?`n")) {
        if (-not $line -or $line.StartsWith('#') -or -not $line.Contains('=')) { continue }
        $key, $value = $line -split '=', 2
        Set-Item -Path "env:$key" -Value $value
        if ($global:BwEnvKeys -notcontains $key) { $global:BwEnvKeys += $key }
        $count++
    }
    Write-Host "bwenv: $Item から $count 個の環境変数を読み込みました"
}

function bwlock {
    foreach ($key in $global:BwEnvKeys) { Remove-Item "env:$key" -ErrorAction SilentlyContinue }
    $global:BwEnvKeys = @()
    if (Get-Command bw -ErrorAction SilentlyContinue) { bw lock *> $null }
    Remove-Item env:BW_SESSION -ErrorAction SilentlyContinue
    Write-Host 'bwlock: 環境変数を消して Bitwarden をロックしました'
}

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

Remove-Variable __cache -ErrorAction SilentlyContinue

# ------------------------------------------------------------
#  マシン固有の設定（git 管理外）
# ------------------------------------------------------------
$__localProfile = Join-Path $HOME '.pwsh_profile.local.ps1'
if (Test-Path $__localProfile) { . $__localProfile }
Remove-Variable __localProfile -ErrorAction SilentlyContinue
__Mark "done"
