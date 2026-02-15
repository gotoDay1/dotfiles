# dotfiles

## 基本構成

- zsh: シェル（sheldonプラグインマネージャー使用）
- neovim: テキストエディタ
- wezterm: ターミナルエミュレーター
- rofi: ランチャー（Linux用）
- lazygit: Gitの操作を簡単にするTUI

## 依存ソフトウェア

以下のソフトウェアが必要です：

- zsh
- nvim (Neovim)
- cargo (Rustのパッケージマネージャー)
- uv
- rofi (Linuxのみ)
- wezterm
- lazygit
- deno (自動インストールを試みます)

## インストール方法

```bash
# リポジトリをクローン
git clone https://github.com/[ユーザー名]/dotfiles.git
cd dotfiles

# インストールスクリプトを実行
./install.sh
```

インストールスクリプトは以下の処理を行います：
- 必要なディレクトリの作成
- 設定ファイルのシンボリックリンク作成またはコピー
- 依存関係のチェック

## 含まれる設定ファイル

### zsh
- `.zshrc`: メインの設定ファイル
- `.zsh/`: 追加の設定ファイルを含むディレクトリ

### neovim
- `.config/nvim/init.lua`: メインの設定ファイル
- `.config/nvim/lua/`: 分割された設定ファイルを含むディレクトリ

### その他
- `.config/sheldon/`: zshプラグインマネージャーの設定
- `.config/rofi/`: ランチャーの設定（Linux用）
- `.config/wezterm/`: ターミナルエミュレーターの設定
- `.config/lazygit/`: lazygitの設定

## 各ソフトウェアの説明

### zsh
プラグインマネージャーにsheldonを採用。rust製のため、`cargo`が実行可能かどうかをチェックします。

```bash
# sheldonのインストール
cargo install sheldon
```

### neovim
プラグインマネージャーにlazy.nvimを採用。init.luaは分割して管理しています。

### wezterm
クロスプラットフォームのターミナルエミュレーター。Rustで書かれており、高速で機能豊富です。

### rofi
Linuxでのランチャー。カスタマイズ可能なアプリケーションランチャーです。
MacOSではraycastを、Windowsの場合はPowerToysのランチャーを使用することをお勧めします。

### lazygit
Gitの操作を簡単にするTUIツール。`.zshrc`には`lg`というエイリアスが設定されています。

## OS別の設定

### Linux
- rofiの設定が含まれています
- 各種設定ファイルは`.config/`ディレクトリにシンボリックリンクされます

### macOS
- Homebrewを使用してパッケージをインストールします
- macOS固有の設定が`.zshrc`に含まれています

## 注意

- 各OSに応じた方法で依存ソフトウェアをインストールしてください
- `.zshrc.local`ファイルを作成することで、gitで管理しない個人的な設定を追加できます
