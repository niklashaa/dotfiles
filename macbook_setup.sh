#!bin/bash

# Software
## Firefox
## Chrome
## KeepassXC
## Spotify

# Homebrew
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
brew install tmux fzf yarn neovim mysql-client the_silver_searcher ctags htop
brew install --HEAD universal-ctags/universal-ctags/universal-ctags
brew tap microsoft/git
brew install --cask git-credential-manager-core
brew install --cask vscodium # Troubleshooting: https://github.com/VSCodium/vscodium/wiki/Troubleshooting#macos

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

# Julia
# 1) Install julia, Add to Applications
# 2) Link julia bin to path
# sudo ln -s /Applications/Julia-1.8.app/Contents/Resources/julia/bin/julia /usr/local/bin/julia
# 3) Add ssh key to gitlab to clone repositories with julia:
#
# ssh-keygen -m PEM -t rsa -b 2048 -C "gitlab-kerith"
# https://docs.gitlab.com/ee/user/ssh.html#add-an-ssh-key-to-your-gitlab-account
# Follow kerith instructions
