# dotfiles

macOS / Linux / Windows で使っている設定ファイル一式。

設定ファイルは全 OS で共通のものを使い、**OS ごとの違いは「シェル」「入口のスクリプト」「パッケージの入れ方」だけ**に閉じ込めています。

| | シェル | パッケージ | セットアップ | kanata の常駐 |
| --- | --- | --- | --- | --- |
| macOS | zsh | `Brewfile` | `./install.sh` | `macos/setup-kanata.sh` (LaunchDaemon) |
| Linux | zsh | apt 等で最低限 + Homebrew on Linux (同じ `Brewfile`) | `./install.sh` | `linux/setup-kanata.sh` (systemd user) |
| Windows | PowerShell 7 | winget (`install.ps1 -Packages`) | `.\install.ps1` | `install.ps1` がスタートアップに登録 |

## ディレクトリ構成

```
.
├── .config/                   # 全 OS 共通
│   ├── nvim/                  #   Neovim (LazyVim)
│   ├── wezterm/               #   WezTerm
│   ├── kanata/                #   kanata (キーリマップ)
│   ├── lazygit/               #   lazygit
│   ├── yazi/                  #   yazi (ファイラー)
│   ├── sheldon/               #   zsh プラグインマネージャー      (macOS / Linux)
│   ├── ghostty/               #   Ghostty                         (macOS / Linux)
│   ├── alacritty/             #   Alacritty (themes は submodule) (macOS / Linux)
│   └── rofi/                  #   rofi                            (Linux)
├── zsh/                       # macOS / Linux
│   ├── zshrc                  #   → ~/.zshrc
│   └── zsh.d/                 #   → ~/.zsh/* (番号順に読み込まれる)
├── powershell/                # Windows
│   └── profile.ps1            #   → $PROFILE
├── install.sh                 # macOS / Linux のセットアップ
├── install.ps1                # Windows のセットアップ
├── Brewfile                   # Homebrew (macOS / Linux 共通)
├── macos/setup-kanata.sh      # kanata を LaunchDaemon として登録
├── linux/setup-kanata.sh      # kanata を systemd ユーザーサービスとして登録
├── scripts/                   # → ~/.scripts/* (Linux)
├── templates/                 # ~/.zshrc.local, ~/.env のひな形
├── .tmux.conf                 # → ~/.tmux.conf
├── .fprettify.rc              # → ~/.fprettify.rc (Fortran フォーマッタ)
└── .latexmkrc_mac             # → ~/.latexmkrc (macOS)
```

## セットアップ

### macOS

```bash
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
git clone --recursive https://github.com/gotoDay1/dotfiles.git ~/dotfiles
cd ~/dotfiles
brew bundle --file=Brewfile
./install.sh
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

1. 設定 > システム > 開発者向け で **開発者モード** を ON (シンボリックリンク作成のため)
2. Git と PowerShell 7 を入れる (Windows PowerShell 5.1 は開発者モードでもシンボリックリンクに管理者権限が必要なため)

```powershell
winget install --id Git.Git -e
winget install --id Microsoft.PowerShell -e
```

3. 新しく開いた `pwsh` で以下を実行

```powershell
git clone --recursive https://github.com/gotoDay1/dotfiles.git $HOME\dotfiles
cd $HOME\dotfiles
pwsh -ExecutionPolicy Bypass -File .\install.ps1 -Packages
```

kanata は [Releases](https://github.com/jtroo/kanata/releases) から `kanata.exe` を PATH の通った場所に置き、
`install.ps1` を再実行するとログオン時の自動起動が登録されます。

`install.ps1` は以下をリンクします。

| リポジトリ | リンク先 |
| --- | --- |
| `powershell/profile.ps1` | `$PROFILE` |
| `.config/nvim` | `%LOCALAPPDATA%\nvim` |
| `.config/wezterm` | `~\.config\wezterm` |
| `.config/lazygit` | `%LOCALAPPDATA%\lazygit` |
| `.config/yazi` | `%APPDATA%\yazi\config` |
| `.config/kanata` | `~\.config\kanata` |

### セットアップスクリプトの動作

どちらも何度実行しても安全です。既存のファイル/ディレクトリは **削除せず** `~/.dotfiles_backup/<日時>/` へ退避してからリンクします。

| | 確認だけ | その他 |
| --- | --- | --- |
| `install.sh` | `--dry-run` | `--no-deps` で依存チェックを省略 |
| `install.ps1` | `-WhatIf` | `-Packages` で winget によるインストールも行う |

`install.sh` は alacritty テーマ (submodule) の取得と、`~/.zshrc.local` が無ければテンプレートからの作成も行います。

## 各ツールのメモ

### Neovim (LazyVim)

- [LazyVim](https://www.lazyvim.org/) をほぼデフォルトで使用 (要 Neovim 0.11.2 以上)
- カスタマイズは以下だけ
  - カラースキーム: catppuccin latte (`lua/plugins/colorscheme.lua`)
  - Windows ではターミナルのシェルを `pwsh` に (`lua/config/options.lua`)
- 初回起動時にプラグインが自動インストールされる。問題があれば `:checkhealth lazyvim`
- treesitter パーサのビルドに C コンパイラが必要 (macOS: Xcode CLT / Linux: build-essential / Windows: MSVC や zig など)

### zsh (macOS / Linux)

- プラグインマネージャーは [sheldon](https://github.com/rossmacarthur/sheldon)。プロンプトは [pure](https://github.com/sindresorhus/pure)
- 読み込み順: `~/.zsh/*.zsh` → `~/.zshrc.local` → sheldon → `compinit`

| 入力 | 内容 |
| --- | --- |
| `lg` | lazygit |
| `lzdo` | lazydocker |
| `y` | yazi を起動し、終了時のディレクトリへ移動 |
| `nv`, `vi` | nvim |
| `proot` | git リポジトリのルートへ移動 |
| `clip` | クリップボードへコピー (pbcopy / wl-copy / xsel) |

### PowerShell (Windows)

- プロンプトは [starship](https://starship.rs/)、`ls` は [eza](https://github.com/eza-community/eza)
- PSReadLine で zsh 風の補完・履歴検索、PSFzf (`Ctrl+r` で履歴検索)
- `$env:PROFILE_TIMING = 1` にして pwsh を起動するとプロファイルの読み込み時間を表示
- 起動を軽くするため、PSFzf は `Ctrl+r` / `Ctrl+.` を初めて押したときに読み込み、starship の初期化スクリプトは `%LOCALAPPDATA%\pwsh-profile-cache` にキャッシュしている (starship 更新時は自動で作り直し。手動で消すなら `Clear-ProfileCache`)

### kanata

キーボードリマッパー。`.config/kanata/kanata.kbd` を全 OS で共有しています。

- CapsLock (HHKB の Ctrl 位置): タップで `Esc`、ホールドで `Ctrl`
- Space: タップで `Space`、ホールドで nav レイヤー (`h/j/k/l` → `←/↓/↑/→`)

手動で試すには `kanata --cfg ~/.config/kanata/kanata.kbd` (macOS では `sudo` が必要)。

### tmux

- prefix は `Ctrl-q`
- `prefix + h/j/k/l` で pane 移動、`H/J/K/L` でリサイズ
- `prefix + |` / `-` で分割 (カレントディレクトリを引き継ぐ)
- `prefix + r` で設定を再読み込み

### ターミナル

- WezTerm (全 OS) / Ghostty / Alacritty の設定を同梱
- Alacritty は起動時に tmux の `main` セッションへ自動アタッチ

### ランチャー

- Linux: rofi / macOS: Raycast / Windows: PowerToys Run

## ローカル設定 (git 管理外)

| ファイル | 用途 |
| --- | --- |
| `~/.zshrc.local` | マシン固有の zsh 設定 (conda の初期化など) |
| `~/.env` | API キーなどの秘密情報 (`KEY=VALUE` 形式) |

ひな形は `templates/` にあります。

## ブランチ運用

- 普段の変更は `develop` (または作業ブランチ → `develop` への PR) に入れる
- 安定性を確認したら `develop` → `main` の PR でマージする
- `main` へは `develop` からの PR しか通らない (`main-guard` ワークフローでチェック)

## CI

GitHub Actions で shellcheck / zsh・Lua・PowerShell の構文チェック / tmux 設定の読み込み / `install.sh --dry-run` を実行しています。
