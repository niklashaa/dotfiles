# dotfiles

Cross-platform dotfiles for macOS and Arch Linux (omarchy), managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Setup

Run the setup script on a fresh machine:

```bash
git clone https://github.com/niklashaa/dotfiles ~/dotfiles
cd ~/dotfiles
./scripts/setup.sh
```

This installs all packages, stows the dotfiles, and creates machine-specific local configs.

## Machine-specific configs

Some configs differ between macOS and Linux. These use a shared base that includes a local file:

| Config | Shared (stowed) | Local (created by setup.sh) | Templates |
|---|---|---|---|
| Alacritty | `.config/alacritty/alacritty.toml` | `.config/alacritty/local.toml` | `local.toml.macos`, `local.toml.omarchy` |
| Git | `.gitconfig` | `.gitconfig.local` | `.gitconfig.local.macos`, `.gitconfig.local.omarchy` |

The local files are gitignored. Templates for each machine are tracked in the repo.

To manually create a local config, copy the right template:
```bash
# macOS
cp ~/dotfiles/.config/alacritty/local.toml.macos ~/.config/alacritty/local.toml
cp ~/dotfiles/.gitconfig.local.macos ~/.gitconfig.local

# omarchy
cp ~/dotfiles/.config/alacritty/local.toml.omarchy ~/.config/alacritty/local.toml
cp ~/dotfiles/.gitconfig.local.omarchy ~/.gitconfig.local
```
