#!bin/bash
# Add shortcuts and corners
# Install zsh
# Install alphred + keypassxc + plank
# Set up google account for keypass database
# Set keyboard to German (US)

# Nvm, node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
# Install npm v16 for nuxt
npm install -g neovim

#Software
## DBeaver
## Firefox developer
## GCM
### https://github.com/GitCredentialManager/git-credential-manager/blob/main/README.md

## Spotify
curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install spotify-client

# Tmux
apt install tmux
sudo apt install fzf # Switch tmux sessions nicely

# VIM
## Treesitter
apt install libc++-dev
# npm install --global tree-sitter
# npm install --global tree-sitter-cli

## Search
apt install silversearcher-ag

## Oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

## Ctags
apt-get install -y exuberant-ctags

## Neovim
sudo add-apt-repository ppa:neovim-ppa/unstable
# sudo add-apt-repository --remove ppa:neovim-ppa/unstable
# sudo apt remove neovim
# sudo apt remove neovim-runtime
# sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt update
sudo apt install neovim

## Battery
curl -O https://raw.githubusercontent.com/holman/spark/master/spark
mv spark /usr/local/bin
chmod u+x /usr/local/bin/spark

curl -O https://raw.githubusercontent.com/goles/battery/master/battery
mv battery /usr/local/bin
chmod u+x /usr/local/bin/battery

## Kerith
apt install mysql-client
npm install --global yarn
npm install -g typescript
### firebase login might only work with Chrome
### => firebase login --no-localhost, copy url into chrome if chrome is not default
npm install -g firebase-tools

# gcloud
sudo apt-get install apt-transport-https ca-certificates gnupg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update && sudo apt-get install google-cloud-cli
sudo apt-get install kubectl
## Init might only work with Chrome
### Copy url into chrome if chrome is not default
gcloud init
