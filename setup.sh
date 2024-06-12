#!/bin/bash

declare -a dotfiles=(".tmux.conf" ".zshrc" ".gitconfig" ".gitignore_global" ".aerospace.toml") #Declare dotfiles as array
DOTFILEDIR=$HOME/.dotfiles
CONFIGDIR=$HOME/.config

for element in "${dotfiles[@]}"
do
    echo "Linking $DOTFILEDIR/${element} to $HOME/$element"
    ln -sf "$DOTFILEDIR/${element}" "$HOME/$element"
done

echo "Linking $DOTFILEDIR/nvim to $CONFIGDIR/nvim"
ln -sf "$DOTFILEDIR/nvim" "$CONFIGDIR/nvim"
