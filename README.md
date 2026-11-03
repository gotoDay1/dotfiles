# dotfiles

macOS / Linux / Windows で使っている設定ファイル一式。

## セットアップ

```bash
git clone --recursive https://github.com/gotoDay1/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

| オプション | 説明 |
| --- | --- |
| `--dry-run`, `-n` | 何も変更せず、実行内容だけを表示する |
| `--no-deps` | 依存関係チェックと deno の自動インストールを省略する |

`install.sh` は以下を行います。

- alacritty テーマ (git submodule) の取得
- 設定ファイルのシンボリックリンク作成
  - 既存のファイル/ディレクトリは **削除せず** `~/.dotfiles_backup/<日時>/` へ退避
  - 何度実行しても安全 (リンク済みのものはスキップ)
- 依存ソフトウェアのチェック (必須 / 任意)
- `~/.zshrc.local` が無ければテンプレートから作成

macOS では先に Homebrew で依存関係をまとめて入れておくと楽です。

```bash
brew bundle --file=macos/Brewfile
```

## ディレクトリ構成

```
.
├── install.sh                 # セットアップスクリプト
├── .zshrc                     # → ~/.zshrc
├── .zsh/                      # → ~/.zsh/*  (番号順に読み込まれる)
│   ├── 01_base.zsh            #   オプション・履歴・~/.env・mise
│   ├── 02_key_config.zsh      #   キーバインド・yazi 連携関数 y
│   ├── 03_path.zsh            #   PATH
│   ├── 04_alias.zsh           #   エイリアス
│   ├── 05_git.zsh             #   git 補完
│   ├── _git                   #   git 補完 (zsh ラッパー)
│   └── git-completion.bash
├── .tmux.conf                 # → ~/.tmux.conf
├── .fprettify.rc              # → ~/.fprettify.rc (Fortran フォーマッタ)
├── .latexmkrc_mac             # → ~/.latexmkrc (macOS のみ)
├── .config/                   # → ~/.config/*
│   ├── nvim/                  #   Neovim (lazy.nvim)
│   ├── sheldon/               #   zsh プラグインマネージャー
│   ├── wezterm/               #   WezTerm
│   ├── ghostty/               #   Ghostty
│   ├── alacritty/             #   Alacritty (themes は submodule)
│   ├── lazygit/               #   lazygit
│   ├── yazi/                  #   yazi (ファイラー)
│   └── rofi/                  #   rofi (Linux のみ)
├── scripts/                   # → ~/.scripts/* (Linux のみ)
├── templates/                 # ~/.zshrc.local, ~/.env のひな形
├── macos/Brewfile             # Homebrew でまとめてインストール
└── windows/                   # Windows 用 (手動で配置)
    ├── Microsoft.PowerShell_profile.ps1
    └── nvim/
```

## 依存ソフトウェア

| 区分 | ソフトウェア |
| --- | --- |
| 必須 | zsh, neovim, git, sheldon, tmux |
| 任意 | mise, uv, cargo, fzf, lazygit, yazi, deno, wezterm / ghostty / alacritty |
| Linux | rofi, xsel (または wl-clipboard) |

deno は ddc.vim / skkeleton で使うため、見つからない場合は `install.sh` が自動でインストールします。

## 各ツールのメモ

### zsh

- プラグインマネージャーは [sheldon](https://github.com/rossmacarthur/sheldon)。プロンプトは [pure](https://github.com/sindresorhus/pure)
- 主なプラグイン: zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions, zsh-abbr
- 読み込み順: `~/.zsh/*.zsh` → `~/.zshrc.local` → sheldon → `compinit`
- 主なエイリアス / abbr

  | 入力 | 内容 |
  | --- | --- |
  | `lg` | lazygit |
  | `lzdo` | lazydocker |
  | `y` | yazi を起動し、終了時のディレクトリへ移動 |
  | `nv`, `vi` | nvim |
  | `proot` | git リポジトリのルートへ移動 |
  | `clip` | クリップボードへコピー (pbcopy / wl-copy / xsel) |

### Neovim

- プラグインマネージャーは [lazy.nvim](https://github.com/folke/lazy.nvim)
- `init.lua` → `lua/base.lua`, `lua/keymaps.lua`, `lua/lazy-setup.lua`, `lua/appearance.lua`
- プラグインは `lua/plugins/` に 1 ファイル 1 プラグインで配置

### tmux

- prefix は `Ctrl-q`
- `prefix + h/j/k/l` で pane 移動、`H/J/K/L` でリサイズ
- `prefix + |` / `-` で分割 (カレントディレクトリを引き継ぐ)
- `prefix + r` で設定を再読み込み

### ターミナル

- WezTerm / Ghostty / Alacritty の設定を同梱
- Alacritty は起動時に tmux の `main` セッションへ自動アタッチ

### ランチャー

- Linux: rofi
- macOS: Raycast / Windows: PowerToys Run を推奨

## ローカル設定 (git 管理外)

| ファイル | 用途 |
| --- | --- |
| `~/.zshrc.local` | マシン固有の zsh 設定 (conda の初期化など) |
| `~/.env` | API キーなどの秘密情報 (`KEY=VALUE` 形式) |

ひな形は `templates/` にあります。

## Windows

`windows/` 以下は手動で配置します。

- `Microsoft.PowerShell_profile.ps1` → `$PROFILE`
- `nvim/` → `%LOCALAPPDATA%\nvim`

## CI

GitHub Actions で shellcheck / zsh・Lua の構文チェック / tmux 設定の読み込み / `install.sh --dry-run` を実行しています。
