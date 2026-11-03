# Windows 用セットアップスクリプト
#
#   .\install.ps1              設定をリンクする
#   .\install.ps1 -Packages    scoop でツールもインストールする
#   .\install.ps1 -WhatIf      実行内容の確認だけ
#
# 実行ポリシーで止められる場合:
#   powershell -ExecutionPolicy Bypass -File .\install.ps1 -Packages
#
# 管理者権限・開発者モードは不要 (会社 PC でも使えるように)。
#   - ディレクトリ: ジャンクション (シンボリックリンクと違い特権が要らない)
#   - PowerShell プロファイル: リポジトリのファイルを読み込む 1 行だけのファイルを置く
#   - パッケージ: scoop (ユーザー領域にインストールされる)
# Windows PowerShell 5.1 / PowerShell 7 のどちらでも動く。
# 既存のファイル/ディレクトリは ~\.dotfiles_backup\<日時>\ に退避する。

[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$Packages
)

$ErrorActionPreference = 'Stop'
$Dotfiles = $PSScriptRoot
$BackupDir = Join-Path $HOME (".dotfiles_backup\" + (Get-Date -Format 'yyyyMMdd_HHmmss'))

function Backup-Item([string]$Path) {
    Write-Host "backup: $Path -> $BackupDir"
    if ($PSCmdlet.ShouldProcess($Path, 'Backup')) {
        New-Item -ItemType Directory -Force $BackupDir | Out-Null
        Move-Item $Path $BackupDir
    }
}

# リポジトリ内のディレクトリをジャンクションでつなぐ
function Link-Dir([string]$Source, [string]$Dest) {
    $src = Join-Path $Dotfiles $Source
    if (-not (Test-Path $src -PathType Container)) {
        Write-Warning "$Source not found in repository, skipping"
        return
    }

    $item = Get-Item $Dest -Force -ErrorAction SilentlyContinue
    if ($item) {
        if ($item.LinkType -and (@($item.Target)[0] -eq $src)) {
            Write-Host "ok     $Dest (already linked)"
            return
        }
        if ($item.LinkType) {
            # 古いリンク/ジャンクションはリンクだけ消す (中身は消えない)
            if ($PSCmdlet.ShouldProcess($Dest, 'Remove old link')) { [IO.Directory]::Delete($Dest) }
        } else {
            Backup-Item $Dest
        }
    }

    if ($PSCmdlet.ShouldProcess($Dest, "Junction to $src")) {
        New-Item -ItemType Directory -Force (Split-Path -Parent $Dest) | Out-Null
        New-Item -ItemType Junction -Path $Dest -Target $src | Out-Null
    }
    Write-Host "link   $Dest -> $src"
}

# ---------------------------------------------------------------------------
# パッケージ (scoop)
# ---------------------------------------------------------------------------
if ($Packages) {
    if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
        Write-Host '==> Installing scoop...'
        if ($PSCmdlet.ShouldProcess('scoop', 'Install')) {
            Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
        }
    }

    $apps = @(
        # main
        'git', 'pwsh', 'neovim', 'fzf', 'ripgrep', 'fd', 'eza', 'zoxide',
        'starship', 'yazi', 'uv', 'mingw', 'bitwarden-cli',
        # extras
        'extras/lazygit', 'extras/kanata'
    )
    if ($PSCmdlet.ShouldProcess(($apps -join ', '), 'scoop install')) {
        if (-not (scoop bucket list | Where-Object Name -eq 'extras')) { scoop bucket add extras }
        scoop install @apps
    }

    # 5.1 から Install-Module すると pwsh 7 から見えない場所に入るので pwsh で入れる
    if ($PSCmdlet.ShouldProcess('PSFzf', 'Install-Module (CurrentUser)')) {
        if (Get-Command pwsh -ErrorAction SilentlyContinue) {
            pwsh -NoProfile -Command 'Install-Module PSFzf -Scope CurrentUser -Force'
        } else {
            Write-Warning 'pwsh が見つからないため PSFzf をインストールできませんでした'
        }
    }
}

# ---------------------------------------------------------------------------
# 設定ディレクトリ
# ---------------------------------------------------------------------------
Write-Host '==> Linking config directories...'
Link-Dir '.config\nvim'    (Join-Path $env:LOCALAPPDATA 'nvim')
Link-Dir '.config\git'     (Join-Path $HOME '.config\git')
Link-Dir '.config\lazygit' (Join-Path $env:LOCALAPPDATA 'lazygit')
Link-Dir '.config\yazi'    (Join-Path $env:APPDATA 'yazi\config')
Link-Dir '.config\kanata'  (Join-Path $HOME '.config\kanata')

# ---------------------------------------------------------------------------
# PowerShell 7 のプロファイル
#   $PROFILE にはリポジトリの profile.ps1 を読み込む 1 行だけを書く
#   (5.1 から実行しても pwsh 7 側のプロファイルに書き込む)
# ---------------------------------------------------------------------------
Write-Host '==> Setting up PowerShell profile...'
$profilePath = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'PowerShell\Microsoft.PowerShell_profile.ps1'
$repoProfile = Join-Path $Dotfiles 'powershell\profile.ps1'
$stub = ". `"$repoProfile`""

$current = if (Test-Path $profilePath) { "$(Get-Content $profilePath -Raw)".Trim() } else { $null }
if ($current -eq $stub) {
    Write-Host "ok     $profilePath (already set)"
} else {
    if ($current -ne $null) { Backup-Item $profilePath }
    if ($PSCmdlet.ShouldProcess($profilePath, 'Write profile stub')) {
        New-Item -ItemType Directory -Force (Split-Path -Parent $profilePath) | Out-Null
        Set-Content -Path $profilePath -Value $stub -Encoding UTF8
    }
    Write-Host "write  $profilePath -> $stub"
}

# ---------------------------------------------------------------------------
# pwsh の起動を軽くするユーザー環境変数
#   プロファイルより前 (pwsh の起動処理中) に読まれるので、プロファイルではなく
#   ユーザー環境変数 (HKCU\Environment) に設定する。管理者権限は不要。
#   反映されるのは、この後に起動したプロセスから
#   (起動中の Windows Terminal などは再起動が必要)。
#     POWERSHELL_UPDATECHECK=Off      起動時の新バージョン確認をしない
#     POWERSHELL_TELEMETRY_OPTOUT=1   利用状況 (テレメトリ) を送信しない
# ---------------------------------------------------------------------------
Write-Host '==> Setting user environment variables for pwsh...'
$userEnv = [ordered]@{
    'POWERSHELL_UPDATECHECK'      = 'Off'
    'POWERSHELL_TELEMETRY_OPTOUT' = '1'
}
foreach ($name in $userEnv.Keys) {
    $value = $userEnv[$name]
    if ([Environment]::GetEnvironmentVariable($name, 'User') -eq $value) {
        Write-Host "ok     $name=$value (already set)"
        continue
    }
    if ($PSCmdlet.ShouldProcess("$name=$value", 'Set user environment variable')) {
        [Environment]::SetEnvironmentVariable($name, $value, 'User')
    }
    Write-Host "set    $name=$value"
}

# ---------------------------------------------------------------------------
# マシン固有の設定 (git 管理外): 無いときだけテンプレートからコピー
# ---------------------------------------------------------------------------
$templates = @{
    'gitconfig.local.example'         = Join-Path $HOME '.gitconfig.local'
    'pwsh_profile.local.ps1.example'  = Join-Path $HOME '.pwsh_profile.local.ps1'
}
foreach ($name in $templates.Keys) {
    $dest = $templates[$name]
    if (-not (Test-Path $dest)) {
        if ($PSCmdlet.ShouldProcess($dest, 'Create from template')) {
            Copy-Item (Join-Path $Dotfiles "templates\$name") $dest
        }
        Write-Host "create $dest (from templates\$name)"
    }
}

# 削除した設定 (wezterm など) を指したまま残っているジャンクションを掃除
$staleLinks = @(
    (Join-Path $HOME '.config\wezterm')
)
foreach ($path in $staleLinks) {
    $item = Get-Item $path -Force -ErrorAction SilentlyContinue
    if ($item -and $item.LinkType -and -not (Test-Path (@($item.Target)[0]))) {
        if ($PSCmdlet.ShouldProcess($path, 'Remove broken link')) { [IO.Directory]::Delete($path) }
        Write-Host "clean  $path (broken link)"
    }
}

# ---------------------------------------------------------------------------
# kanata: ログオン時に自動起動するショートカット (スタートアップフォルダ)
# ---------------------------------------------------------------------------
$kanata = Get-Command kanata -ErrorAction SilentlyContinue
if ($kanata) {
    $lnk = Join-Path ([Environment]::GetFolderPath('Startup')) 'kanata.lnk'
    if ($PSCmdlet.ShouldProcess($lnk, 'Create kanata startup shortcut')) {
        $sc = (New-Object -ComObject WScript.Shell).CreateShortcut($lnk)
        $sc.TargetPath = $kanata.Source
        $sc.Arguments = '--cfg "' + (Join-Path $Dotfiles '.config\kanata\kanata.kbd') + '"'
        $sc.WindowStyle = 7  # 最小化で起動
        $sc.Save()
    }
    Write-Host "kanata startup shortcut: $lnk"
} else {
    Write-Host 'kanata が見つかりません (scoop install extras/kanata で入れてから再実行すると自動起動を設定します)'
}

Write-Host 'Installation completed!'
