cd ~
mkdir .dotfiles && cd .dotfiles
git clone git@github.com:niklashaa/dotfiles.git
./dotfiles_setup.sh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cd ~/.local/share
git clone https://github.com/universal-ctags/ctags.git
cd ctags
apt install gcc make pkg-config autoconf automake python3-docutils libseccomp-dev libjansson-dev libyaml-dev libxml2-dev
./autogen.sh
./configure --prefix=/where/you/want # defaults to /usr/local
make
make install # may require extra privileges depending on where to install


apt install atom
