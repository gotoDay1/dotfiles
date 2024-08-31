#! /bin/bash

if [ ! -d ~/.config ]; then
    mkdir ~/.config
fi

slinkfiles=(.vimrc .tmux.conf .zsh)
for file in "${slinkfiles[@]}"; do
    ln -svf $PWD/$file ~/
done

cpfiles=(.zshrc)
for file in "${cpfiles[@]}";do
    cp $PWD/$file ~/
done

contents=(sheldon nvim rofi alacritty)
for config in "${contents[@]}"; do
    ln -svf $PWD/.config/$config ~/.config
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
if [ ! -x "$(command -v uv)"]; then
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
