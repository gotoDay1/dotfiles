#! /bin/bash

if [ ! -d ~/.config ]; then
    mkdir ~/.config
fi

if [ ! -d ~/.zsh ]; then
    mkdir ~/.zsh
fi
slinkfiles=(.zsh/*)
for file in "${slinkfiles[@]}"; do
    ln -sv $PWD/$file ~/.zsh/
done

slinkfiles=(.vimrc .tmux.conf)
for file in "${slinkfiles[@]}"; do
    ln -sv $PWD/$file ~/
done

cpfiles=(.zshrc)
for file in "${cpfiles[@]}";do
    cp $PWD/$file ~/
done

contents=(sheldon nvim rofi alacritty wezterm lazygit)
for config in "${contents[@]}"; do
    ln -sv PWD/.config/$config ~/.config
done

# 依存性チェック
if [ ! -x "$(command -v nvim)" ]; then
    echo "nvim is not installed"
fi
if [ ! -x "$(command -v zsh)" ]; then
    echo "zsh is not installed"
fi
if [ ! -x "$(command -v cargo)" ]; then
    echo "cargo is not installed"
fi
if [ ! -x "$(command -v uv)" ]; then
    echo "uv is not installed"
fi
if [ ! -x "$(command -v tmux)" ]; then
    echo "tmux is not installed"
fi
if [ ! -x "$(command -v rofi)" ]; then
    echo "rofi is not installed"
fi
if [ ! -x "$(command -v alacritty)" ]; then
    echo "alacritty is not installed"
fi
if [ ! -x "$(command -v lazygit)" ]; then
    echo "lazygit is not installed"
fi

if [ ! -x "$(command -v deno)" ]; then
    echo "deno is not installed, automatically install deno"
    curl -fsSL https://deno.land/install.sh | sh
fi

