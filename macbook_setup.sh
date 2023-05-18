#!bin/bash

# Software
## Firefox
## Chrome
## KeepassXC
## Spotify

# Homebrew
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
brew install tmux fzf yarn neovim mysql-client the_silver_searcher ctags
brew install --HEAD universal-ctags/universal-ctags/universal-ctags
brew tap microsoft/git
brew install --cask git-credential-manager-core

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
nvm install --lts
nvm install lts/gallium
nmv use lts/gallium
nvm alias default lts/gallium

npm install -g typescript
### firebase login might only work with Chrome
### => firebase login --no-localhost, copy url into chrome if chrome is not default
npm install -g firebase-tools
