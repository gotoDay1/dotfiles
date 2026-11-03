# Windows 用セットアップスクリプト
#
#   (PowerShell 7 で実行すること)
#   pwsh -ExecutionPolicy Bypass -File .\install.ps1             # リンク作成のみ
#   pwsh -ExecutionPolicy Bypass -File .\install.ps1 -Packages   # winget でツールも入れる
#   pwsh -ExecutionPolicy Bypass -File .\install.ps1 -WhatIf     # 実行内容の確認だけ
#
# シンボリックリンクの作成には「開発者モード」を有効にするか、管理者として実行する必要がある。
# 既存のファイル/ディレクトリは ~\.dotfiles_backup\<日時>\ に退避する。

#Requires -Version 7
[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$Packages
)

$ErrorActionPreference = 'Stop'
$Dotfiles = $PSScriptRoot
$BackupDir = Join-Path $HOME (".dotfiles_backup\" + (Get-Date -Format 'yyyyMMdd_HHmmss'))

function Link-Item {
    param([string]$Source, [string]$Dest)

    $src = Join-Path $Dotfiles $Source
    if (-not (Test-Path $src)) {
        Write-Warning "$Source not found in repository, skipping"
        return
    }

    $item = Get-Item $Dest -Force -ErrorAction SilentlyContinue
    if ($item) {
        if ($item.LinkType -eq 'SymbolicLink' -and $item.Target -eq $src) {
            Write-Host "✔  $Dest (already linked)"
            return
        }
        if ($item.LinkType) {
            if ($PSCmdlet.ShouldProcess($Dest, 'Remove old link')) { $item.Delete() }
        } else {
            Write-Host "📦 backup: $Dest -> $BackupDir"
            if ($PSCmdlet.ShouldProcess($Dest, 'Backup')) {
                New-Item -ItemType Directory -Force $BackupDir | Out-Null
                Move-Item $Dest $BackupDir
            }
        }
    }

    if ($PSCmdlet.ShouldProcess($Dest, "Link to $src")) {
        New-Item -ItemType Directory -Force (Split-Path -Parent $Dest) | Out-Null
        New-Item -ItemType SymbolicLink -Path $Dest -Target $src | Out-Null
    }
    Write-Host "🔗 $Dest -> $src"
}

# ---------------------------------------------------------------------------
# パッケージ (winget)
# ---------------------------------------------------------------------------
if ($Packages) {
    $ids = @(
        'Git.Git'
        'Microsoft.PowerShell'
        'Neovim.Neovim'
        'wez.wezterm'
        'JesseDuffield.lazygit'
        'sxyazi.yazi'
        'junegunn.fzf'
        'BurntSushi.ripgrep.MSVC'
        'sharkdp.fd'
        'eza-community.eza'
        'Starship.Starship'
        'astral-sh.uv'
    )
    foreach ($id in $ids) {
        if ($PSCmdlet.ShouldProcess($id, 'winget install')) {
            winget install --id $id --exact --silent --accept-package-agreements --accept-source-agreements
        }
    }
    if ($PSCmdlet.ShouldProcess('PSFzf', 'Install-Module')) {
        Install-Module PSFzf -Scope CurrentUser -Force
    }
}

# ---------------------------------------------------------------------------
# リンク
# ---------------------------------------------------------------------------
Write-Host '==> Linking config files...'
Link-Item 'powershell\profile.ps1' $PROFILE.CurrentUserCurrentHost
Link-Item '.config\nvim'          (Join-Path $env:LOCALAPPDATA 'nvim')
Link-Item '.config\wezterm'       (Join-Path $HOME '.config\wezterm')
Link-Item '.config\lazygit'       (Join-Path $env:LOCALAPPDATA 'lazygit')
Link-Item '.config\yazi'          (Join-Path $env:APPDATA 'yazi\config')
Link-Item '.config\kanata'        (Join-Path $HOME '.config\kanata')

# ---------------------------------------------------------------------------
# kanata: ログオン時に自動起動するショートカットを作成
# ---------------------------------------------------------------------------
$kanata = Get-Command kanata -ErrorAction SilentlyContinue
if ($kanata) {
    $startup = [Environment]::GetFolderPath('Startup')
    $lnk = Join-Path $startup 'kanata.lnk'
    if ($PSCmdlet.ShouldProcess($lnk, 'Create kanata startup shortcut')) {
        $shell = New-Object -ComObject WScript.Shell
        $sc = $shell.CreateShortcut($lnk)
        $sc.TargetPath = $kanata.Source
        $sc.Arguments = '--cfg "' + (Join-Path $HOME '.config\kanata\kanata.kbd') + '"'
        $sc.WindowStyle = 7  # 最小化で起動
        $sc.Save()
    }
    Write-Host "⌨  kanata startup shortcut: $lnk"
} else {
    Write-Host '➖ kanata が見つかりません。https://github.com/jtroo/kanata/releases から kanata.exe を'
    Write-Host '   PATH の通った場所 (例: ~\.local\bin) に置いてから再実行すると自動起動を設定します。'
}

Write-Host 'Installation completed!'
