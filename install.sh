#! /bin/bash

slinkfiles=(.vimrc .tmux.conf .zsh)
for file in "${slinkfiles[@]}"; do
    ln -svf $PWD/$file ~/
done

cpfiles=(.zshrc)
for file in "${cpfiles[@]}";do
    cp $PWD/$file ~/
done

contents=(sheldon nvim rofi)
for config in "${contents[@]}"; do
    ln -svf $PWD/.config/$config ~/.config
done
