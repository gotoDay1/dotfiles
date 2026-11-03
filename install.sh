#!/usr/bin/env bash

# エラー時に停止するように設定
set -e

# スクリプトのディレクトリを取得（どこから実行しても正しく動作するように）
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 必要なディレクトリの作成
mkdir -p ~/.config
mkdir -p ~/.zsh

# .zshディレクトリ内のファイルをシンボリックリンク
echo "Linking .zsh files..."
slinkfiles=(.zsh/*)
for file in "${slinkfiles[@]}"; do
    target=~/"$file"
    if [ -e "$target" ] || [ -L "$target" ]; then
        echo "Warning: $target already exists, skipping..."
    else
        ln -sv "$SCRIPT_DIR/$file" ~/.zsh/
    fi
done
if [ ! -e ~/.zsh/.zshrc ]; then
    ln -sv "$SCRIPT_DIR/.zshrc" ~/.zsh/
fi

# ホームディレクトリに直接リンクするファイル
echo "Linking dotfiles to home directory..."
slinkfiles=(.vimrc .tmux.conf .fprettify.rc)
for file in "${slinkfiles[@]}"; do
    target=~/"$file"
    if [ -e "$target" ] || [ -L "$target" ]; then
        echo "Warning: $target already exists. Unlink it before continuing."
        unlink "$target"
        ln -sv "$SCRIPT_DIR/$file" ~/
    else
        ln -sv "$SCRIPT_DIR/$file" ~/
    fi
done

# .configディレクトリへのシンボリックリンク
echo "Linking config directories..."
contents=(sheldon nvim rofi alacritty wezterm lazygit yazi ghostty)
for config in "${contents[@]}"; do
    target=~/.config/"$config"
    if [ -e "$target" ] || [ -L "$target" ]; then
        echo "Warning: $target already exists. Unlink it before continuing."
        unlink "$target"
        ln -sv "$SCRIPT_DIR/.config/$config" ~/.config
    else
        ln -sv "$SCRIPT_DIR/.config/$config" ~/.config
    fi
done

# 依存性チェック
echo "Checking dependencies..."
dependencies=(nvim zsh cargo uv tmux rofi alacritty wezterm lazygit yazi)
missing_deps=0

for dep in "${dependencies[@]}"; do
    if ! command -v "$dep" &> /dev/null; then
        echo "❌ $dep is not installed"
        missing_deps=$((missing_deps + 1))
    else
        echo "✅ $dep is installed"
    fi
done

# Denoのインストール（存在しない場合）
if ! command -v deno &> /dev/null; then
    echo "❌ deno is not installed, attempting to install..."
    curl -fsSL https://deno.land/install.sh | sh
    if [ $? -eq 0 ]; then
        echo "✅ deno installed successfully"
    else
        echo "❌ Failed to install deno"
        missing_deps=$((missing_deps + 1))
    fi
else
    echo "✅ deno is installed"
fi

# 依存関係の状態を表示
if [ $missing_deps -gt 0 ]; then
    echo "⚠️ $missing_deps dependencies are missing. Please install them for full functionality."
else
    echo "🎉 All dependencies are installed!"
fi

echo "Installation completed!"

# local に依存する設定のため .zshrc.localファイルの作成を促す
echo "Please create a .zshrc.local file in your home directory for local settings."
