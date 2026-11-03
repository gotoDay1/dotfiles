# One-line setup for a new Windows machine (no admin rights required).
#
#   Invoke-RestMethod https://raw.githubusercontent.com/gotoDay1/dotfiles/main/bootstrap.ps1 | Invoke-Expression
#
# Runs: scoop (installed if missing) -> git -> clone -> install.ps1 -Packages
#
# Environment variables
#   DOTFILES_DIR     clone destination (default: ~\dotfiles)
#   DOTFILES_BRANCH  branch (default: main)
#
# NOTE: keep this file ASCII-only. It is fed to Invoke-Expression as a string,
#       and Windows PowerShell 5.1 would also misread non-ASCII text without a BOM.

$ErrorActionPreference = 'Stop'

$repoUrl = 'https://github.com/gotoDay1/dotfiles.git'
$dir = if ($env:DOTFILES_DIR) { $env:DOTFILES_DIR } else { Join-Path $HOME 'dotfiles' }
$branch = if ($env:DOTFILES_BRANCH) { $env:DOTFILES_BRANCH } else { 'main' }

# Allow running scripts (scoop, install.ps1)
if ((Get-ExecutionPolicy) -in 'Restricted', 'AllSigned', 'Undefined') {
    try {
        Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force
    } catch {
        Write-Warning 'Could not change the CurrentUser execution policy (probably restricted by Group Policy). Allowing scripts for this session only.'
        Set-ExecutionPolicy -Scope Process Bypass -Force
    }
}

if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host '==> Installing scoop'
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host '==> Installing git'
    scoop install git
}

if (Test-Path (Join-Path $dir '.git')) {
    Write-Host "==> Updating $dir"
    git -C $dir pull --ff-only
} else {
    Write-Host "==> Cloning into $dir"
    git clone --branch $branch $repoUrl $dir
}

& (Join-Path $dir 'install.ps1') -Packages
