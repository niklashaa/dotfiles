#!/bin/bash

# For this to work we need a $DOTFIELDIR at $HOME/.dotfiles/Dotfiles

declare -a dotfiles=(".tmux.conf" ".vim" ".vimrc" ".zshrc" ".gitconfig" ".gitignore_global") #Declare dotfiles as array
DOTFILEDIR=$HOME/.dotfiles/Dotfiles

for element in "${dotfiles[@]}"
do
    echo "Linking $DOTFILEDIR/${element:1}.symlink to $HOME/$element"
    ln -sf "$DOTFILEDIR/${element:1}.symlink" "$HOME/$element" 
done
