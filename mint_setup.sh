#!bin/bash
# Add shortcuts and corners
# Install zsh
# Install alphred + keypassxc + plank
# Set up google account for keypass database
apt install silversearcher-ag
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cd ~/.local/share
git clone https://github.com/universal-ctags/ctags.git
cd ctags
apt install gcc make pkg-config autoconf automake python3-docutils libseccomp-dev libjansson-dev libyaml-dev libxml2-dev
./autogen.sh
./configure --prefix=/where/you/want # defaults to /usr/local
make
make install # may require extra privileges depending on where to install

# Install firefox developer
mkdir /opt/firefox-developer

# Install newest neovim
sudo add-apt-repository ppa:neovim-ppa/unstable
# sudo add-apt-repository --remove ppa:neovim-ppa/unstable
# sudo apt remove neovim
# sudo apt remove neovim-runtime
# sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt update
sudo apt install neovim

# Battery for tmux
curl -O https://raw.githubusercontent.com/holman/spark/master/spark
mv spark /usr/local/bin
chmod u+x /usr/local/bin/spark

curl -O https://raw.githubusercontent.com/goles/battery/master/battery
mv battery /usr/local/bin
chmod u+x /usr/local/bin/battery

# Needed for switching tmux sessions nicely
sudo apt-get install fzf

## Kerith

# gcloud
sudo apt-get install apt-transport-https ca-certificates gnupg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update && sudo apt-get install google-cloud-cli
sudo apt-get install kubectl
gcloud init
