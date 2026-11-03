# dotfiles

macOS / Linux / Windows で使っている設定ファイル一式。

## セットアップ

設定ファイルは全 OS で共通のものを使い、**OS ごとの違いは「入口のスクリプト」と「パッケージの入れ方」だけ**に閉じ込めています。

| | パッケージ | 設定のリンク | kanata の常駐 |
| --- | --- | --- | --- |
| macOS | `brew bundle` (Brewfile) | `./install.sh` | `macos/setup-kanata.sh` (LaunchDaemon) |
| Linux | apt 等で最低限 + Homebrew on Linux (同じ Brewfile) | `./install.sh` | `linux/setup-kanata.sh` (systemd user) |
| Windows | winget (`install.ps1 -Packages`) | `windows/install.ps1` | `install.ps1` がスタートアップに登録 |

### macOS

```bash
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
git clone --recursive https://github.com/gotoDay1/dotfiles.git ~/dotfiles
cd ~/dotfiles
brew bundle --file=Brewfile
./install.sh
chsh -s "$(which zsh)"
```

kanata を使う場合は、kanata のリリースノートで指定されている版の
[Karabiner-DriverKit-VirtualHIDDevice](https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases)
を入れてドライバを有効化し、「入力監視」で kanata を許可してから以下を実行します。

```bash
./macos/setup-kanata.sh
```

### Linux

```bash
# Debian / Ubuntu の例 (Homebrew のビルドに必要なものと zsh)
sudo apt install -y build-essential curl git zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
git clone --recursive https://github.com/gotoDay1/dotfiles.git ~/dotfiles
cd ~/dotfiles
brew bundle --file=Brewfile        # cask (GUI アプリ) は macOS のみ
./install.sh
chsh -s "$(which zsh)"
./linux/setup-kanata.sh            # kanata を使う場合 (sudo を使う。実行後に再ログイン)
```

ターミナル (WezTerm / Ghostty / Alacritty)、rofi、フォントは各ディストリのパッケージで入れてください。

### Windows

`windows/install.ps1` が以下をリンクします。

| リポジトリ | リンク先 |
| --- | --- |
| `windows/Microsoft.PowerShell_profile.ps1` | `$PROFILE` |
| `windows/nvim` | `%LOCALAPPDATA%\nvim` |
| `.config/wezterm` | `~\.config\wezterm` |
| `.config/lazygit` | `%LOCALAPPDATA%\lazygit` |
| `.config/yazi` | `%APPDATA%\yazi\config` |
| `.config/kanata` | `~\.config\kanata` |

## CI

GitHub Actions で shellcheck / zsh・Lua の構文チェック / tmux 設定の読み込み / `install.sh --dry-run` を実行しています。
