# dotfiles

macOS / Linux / Windows で使っている設定ファイル一式。

設定ファイルは全 OS で共通のものを使い、**OS ごとの違いは「シェル」「入口のスクリプト」「パッケージの入れ方」だけ**に閉じ込めています。

| | シェル | ターミナル | パッケージ | セットアップ | kanata の常駐 |
| --- | --- | --- | --- | --- | --- |
| macOS | zsh | Ghostty | `Brewfile` | `./install.sh` | `macos/setup-kanata.sh` (LaunchDaemon) |
| Linux | zsh | Ghostty | apt 等で最低限 + Homebrew on Linux (同じ `Brewfile`) | `./install.sh` | `linux/setup-kanata.sh` (systemd user) |
| Windows | PowerShell 7 | Windows Terminal | scoop (`install.ps1 -Packages`) | `.\install.ps1` | `install.ps1` がスタートアップに登録 |

## クイックスタート

```bash
# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/gotoDay1/dotfiles/main/bootstrap.sh | bash -s -- --packages
```

```powershell
# Windows (管理者ではない PowerShell で)
Invoke-RestMethod https://raw.githubusercontent.com/gotoDay1/dotfiles/main/bootstrap.ps1 | Invoke-Expression
```

clone 先は `~/dotfiles`。`DOTFILES_DIR` / `DOTFILES_BRANCH` 環境変数で変更できます。
セットアップ後にやることは [初回セットアップ後](#初回セットアップ後) を参照。

## ディレクトリ構成

```
.
├── .config/                   # 全 OS 共通
│   ├── nvim/                  #   Neovim (LazyVim)
│   ├── git/                   #   git (config, ignore)
│   ├── starship.toml          #   プロンプト (zsh / PowerShell 共通)
│   ├── kanata/                #   kanata (キーリマップ)
│   ├── lazygit/               #   lazygit
│   ├── lf/                    #   lf (ファイラー)
│   ├── sheldon/               #   zsh プラグインマネージャー (macOS / Linux)
│   ├── ghostty/               #   Ghostty                    (macOS / Linux)
│   └── rofi/                  #   rofi                       (Linux)
├── zsh/                       # macOS / Linux
│   ├── zshenv                 #   → ~/.zshenv
│   ├── zshrc                  #   → ~/.zshrc
│   └── zsh.d/                 #   → ~/.zsh/* (番号順に読み込まれる)
├── powershell/                # Windows
│   └── profile.ps1            #   $PROFILE から読み込まれる
├── bootstrap.sh / .ps1        # 1 行セットアップ (clone → install)
├── install.sh                 # macOS / Linux のセットアップ
├── install.ps1                # Windows のセットアップ
├── Brewfile                   # Homebrew (macOS / Linux 共通)
├── macos/setup-kanata.sh      # kanata を LaunchDaemon として登録
├── linux/setup-kanata.sh      # kanata を systemd ユーザーサービスとして登録
├── templates/                 # git 管理外のローカル設定のひな形
├── .tmux.conf                 # → ~/.tmux.conf
├── .fprettify.rc              # → ~/.fprettify.rc (Fortran フォーマッタ)
└── .latexmkrc_mac             # → ~/.latexmkrc (macOS)
```

## セットアップ (手動)

[クイックスタート](#クイックスタート) の中身を 1 ステップずつ行う場合の手順です。

### macOS

```bash
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
git clone https://github.com/gotoDay1/dotfiles.git ~/dotfiles
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
git clone https://github.com/gotoDay1/dotfiles.git ~/dotfiles
cd ~/dotfiles
brew bundle --file=Brewfile        # cask (GUI アプリ) は macOS のみ
./install.sh
chsh -s "$(which zsh)"
./linux/setup-kanata.sh            # kanata を使う場合 (sudo を使う。実行後に再ログイン)
```

Ghostty、rofi、フォントは各ディストリのパッケージで入れてください。

### Windows

**管理者権限・開発者モードは不要**です (会社 PC でも使えるように、シンボリックリンクと winget を使っていません)。

1. 標準の Windows PowerShell を **管理者ではなく** 普通に開き、以下を実行

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned    # スクリプトの実行を許可 (未設定の場合)
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
scoop install git
git clone https://github.com/gotoDay1/dotfiles.git $HOME\dotfiles
cd $HOME\dotfiles
.\install.ps1 -Packages
```

2. 以降は PowerShell 7 (`pwsh`) を使う。Windows Terminal の「設定 > スタートアップ > 既定のプロファイル」を PowerShell 7 にしておく

`-Packages` を付けると scoop で以下をユーザー領域にインストールします。

- main: git, pwsh, neovim, fzf, ripgrep, fd, eza, zoxide, starship, lf, uv, mingw (treesitter のビルド用), bitwarden-cli
- extras: lazygit, kanata
- PowerShell モジュール: PSFzf (CurrentUser)

`install.ps1` は以下のように設定をつなぎます。

| リポジトリ | 配置先 | 方法 |
| --- | --- | --- |
| `powershell/profile.ps1` | `Documents\PowerShell\Microsoft.PowerShell_profile.ps1` | リポジトリのファイルを読み込む 1 行だけを書く |
| `.config/nvim` | `%LOCALAPPDATA%\nvim` | ジャンクション |
| `.config/git` | `~\.config\git` | ジャンクション |
| `.config/lazygit` | `%LOCALAPPDATA%\lazygit` | ジャンクション |
| `.config/lf` | `%APPDATA%\lf` | ジャンクション |
| `.config/kanata` | `~\.config\kanata` | ジャンクション (+ スタートアップに kanata のショートカットを作成) |
| `.config/starship.toml` | — | `profile.ps1` が `STARSHIP_CONFIG` でリポジトリのファイルを直接指定 |

ジャンクションはシンボリックリンクと違い、作成に特権が要りません (ディレクトリ専用)。

会社のグループポリシーでスクリプトの実行が禁止されている場合は `Set-ExecutionPolicy` が効かないことがあります。その場合は社内の管理者に確認してください。

### セットアップスクリプトの動作

どちらも何度実行しても安全です。既存のファイル/ディレクトリは **削除せず** `~/.dotfiles_backup/<日時>/` へ退避してから配置します。
削除した設定 (alacritty, wezterm など) を指したまま残っているリンクは自動で掃除します。

| | 確認だけ | その他 |
| --- | --- | --- |
| `install.sh` | `--dry-run` | `--no-deps` で依存チェックを省略 |
| `install.ps1` | `-WhatIf` | `-Packages` で scoop によるインストールも行う |

## 初回セットアップ後

1. **git の名前・メールアドレス**: `~/.gitconfig.local` を編集する (会社用は [git](#git) を参照)
2. **Bitwarden**: `bw login` を一度実行し、[秘密情報](#秘密情報-bitwarden-cli) のアイテムを作る
3. **Neovim**: `nvim` を起動するとプラグインが自動インストールされる

## 各ツールのメモ

### Neovim (LazyVim)

- [LazyVim](https://www.lazyvim.org/) をほぼデフォルトで使用 (要 Neovim 0.11.2 以上)
- カスタマイズは以下だけ
  - カラースキーム: catppuccin latte (`lua/plugins/colorscheme.lua`)
  - Windows ではターミナルのシェルを `pwsh` に (`lua/config/options.lua`)
- 問題があれば `:checkhealth lazyvim`
- treesitter パーサのビルドに C コンパイラが必要 (macOS: Xcode CLT / Linux: build-essential / Windows: scoop の mingw)

### プロンプト (starship)

- zsh / PowerShell の両方で [starship](https://starship.rs/) を使い、設定は `.config/starship.toml` の 1 つだけ
- 以前の pure に近い 2 行のシンプルな見た目 (ディレクトリ・ブランチ・git の状態・実行時間)

### git

`.config/git/` を `~/.config/git/` に配置しています (全 OS 共通)。

- `config`: エイリアス (`st`, `sw`, `lg` など)、`pull.rebase`、`push.autoSetupRemote`、`zdiff3` など
- `ignore`: 全リポジトリ共通の gitignore (`.DS_Store`, `Thumbs.db`, `.env` など)

名前・メールアドレスはマシンごとに `~/.gitconfig.local` (git 管理外) に書きます。
会社のリポジトリを `~/work/` 以下に置くと、`~/.gitconfig.work` の設定 (会社のメールアドレスなど) が自動で使われます。

```ini
# ~/.gitconfig.work
[user]
    email = you@company.example
```

### 秘密情報 (Bitwarden CLI)

API キーなどはファイルに置かず、Bitwarden から必要なときに読み込みます。

1. Bitwarden に **セキュアメモ** を `dotfiles-env` という名前で作り、メモ欄に `KEY=VALUE` 形式で書く

   ```
   # コメント行と空行は無視される
   OPENAI_API_KEY=sk-...
   ANTHROPIC_API_KEY=sk-ant-...
   ```

2. 初回だけ `bw login`
3. 使いたいときに `bwenv` (zsh / PowerShell 共通)

| コマンド | 内容 |
| --- | --- |
| `bwenv` | `dotfiles-env` の内容を環境変数に読み込む (ロック中ならマスターパスワードを聞かれる) |
| `bwenv <アイテム名>` | 別のアイテムを読み込む (例: 会社用に `work-env`) |
| `bwlock` | 読み込んだ環境変数を消して Bitwarden をロックする |

既定のアイテム名は `BW_ENV_ITEM` 環境変数で変えられます (`~/.zshrc.local` や `~/.pwsh_profile.local.ps1` で設定)。
読み込んだ環境変数はそのシェルだけで有効です。値はクォートせずにそのまま書いてください。

### zsh (macOS / Linux)

- プラグインマネージャーは [sheldon](https://github.com/rossmacarthur/sheldon)。プラグインは zsh-completions / zsh-autosuggestions / history-search-multi-word / zsh-abbr / zsh-syntax-highlighting
- 読み込み順: `~/.zsh/*.zsh` → `~/.zshrc.local` → sheldon → zsh-abbr の略語 / fzf / zoxide / starship → `compinit`
- git の補完は zsh 標準のもの (オプションやサブコマンドに説明が付く)
- `~/.zshenv` で Ubuntu / Debian のシステム側の `compinit` を止めている (`compinit` は `~/.zshrc` で一度だけ)。rustup などが `~/.zshenv` に書き込む内容は `~/.zshenv.local` に書く

起動を軽くするための工夫:

- autosuggestions と syntax-highlighting は [zsh-defer](https://github.com/romkatv/zsh-defer) で遅延ロード (プロンプトが出たあとに読み込む)
- `sheldon source` / starship / fzf / zoxide / mise の初期化スクリプトを `~/.cache/zsh/` にキャッシュ。コマンドや `plugins.toml` が更新されたときだけ作り直す (手動で消すなら `zsh-cache-clear`)
- 起動時間の内訳は `ZPROF=1 zsh -i -c exit` で確認できる

| 入力 | 内容 |
| --- | --- |
| `Ctrl-R` | 履歴を複数の単語で検索 (history-search-multi-word) |
| `Ctrl-T` | ファイルをあいまい検索してコマンドラインに挿入 (fzf) |
| `Alt-C` | ディレクトリをあいまい検索して移動 (fzf) |
| `z <キーワード>` | よく使うディレクトリへ移動 (zoxide)。`zi` で候補から選択 |
| `lf` | ファイラー。閉じたときのディレクトリへ移動する (詳しくは [lf](#lf-ファイラー)) |
| `lg` / `lzdo` | lazygit / lazydocker (zsh-abbr の略語。入力すると展開される) |
| `nv`, `vi` | nvim |
| `proot` | git リポジトリのルートへ移動 |
| `clip` | クリップボードへコピー (pbcopy / wl-copy / xsel) |

### PowerShell (Windows)

- `ls` は [eza](https://github.com/eza-community/eza)
- PSReadLine で zsh 風の補完・履歴検索、PSFzf (`Ctrl+r` で履歴検索)
- `z <キーワード>` でよく使うディレクトリへ移動 (zoxide、zsh と同じ使い方)
- `$env:PROFILE_TIMING = 1` にして pwsh を起動するとプロファイルの読み込み時間を表示
- `install.ps1` がユーザー環境変数 `POWERSHELL_UPDATECHECK=Off` (起動時の新バージョン確認をしない) と `POWERSHELL_TELEMETRY_OPTOUT=1` (利用状況を送信しない) を設定する。pwsh の起動処理中に読まれるのでプロファイルには書けない。反映は新しく起動したプロセスから
- 起動を軽くするため、PSFzf は `Ctrl+r` / `Ctrl+.` を初めて押したときに読み込み、starship と zoxide の初期化スクリプトは `%LOCALAPPDATA%\pwsh-profile-cache` にキャッシュしている (コマンド更新時は自動で作り直し。手動で消すなら `Clear-ProfileCache`)

### lf (ファイラー)

[lf](https://github.com/gokcehan/lf) を使っています (全 OS 共通の `.config/lf/lfrc`)。シェルから `lf` で起動すると、閉じたときのディレクトリへ移動します (zsh / PowerShell の両方)。

| キー | 内容 |
| --- | --- |
| `m<文字>` | 今のディレクトリをブックマークに登録 (閉じても残る。保存先はマシンごと) |
| `'<文字>` | 登録したディレクトリへ移動 (`''` で直前のディレクトリ) |
| `"<文字>` | ブックマークを削除 |
| `gh` / `gc` / `gd` / `gf` / `gw` | ホーム / `~/.config` / Downloads / dotfiles / `~/work` へ移動 (全マシン共通の固定ブックマーク。`lfrc` に追加できる) |
| `/` | 検索しながら移動 |
| `zh` | 隠しファイルの表示切り替え |
| `e` | `$EDITOR` (nvim) で開く |

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

### ランチャー

- Linux: rofi / macOS: Raycast / Windows: PowerToys Run

## ローカル設定 (git 管理外)

| ファイル | 用途 |
| --- | --- |
| `~/.zshrc.local` | マシン固有の zsh 設定 (conda の初期化など) |
| `~/.pwsh_profile.local.ps1` | マシン固有の PowerShell 設定 (会社のプロキシなど) |
| `~/.gitconfig.local` | git の名前・メールアドレス、会社用設定の切り替え |
| `~/.gitconfig.work` | 会社のリポジトリ用の git 設定 (任意) |

`~/.gitconfig.work` 以外は、無ければセットアップ時に `templates/` からコピーされます。

## ブランチ運用

- 普段の変更は `develop` (または作業ブランチ → `develop` への PR) に入れる
- 安定性を確認したら `develop` → `main` の PR でマージする
- `main` へは `develop` からの PR しか通らない (`main-guard` ワークフローでチェック)
- クイックスタートは `main` を clone するので、`main` は常に動く状態を保つ

## CI

| ワークフロー | 内容 |
| --- | --- |
| `lint` | shellcheck / zsh・Lua・PowerShell の構文チェック / TOML・git config の読み込み / tmux 設定の読み込み / `install.sh --dry-run` |
| `install-test` | Ubuntu・macOS で `install.sh`、Windows (PowerShell 5.1 / 7) で `install.ps1` を 2 回ずつ実行し、リンクとプロファイルが正しく作られることを確認 |
| `main-guard` | `main` への PR が `develop` からかを確認 |
