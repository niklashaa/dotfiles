#!/bin/bash
set -e

DOTFILES_REPO="https://github.com/niklashaa/dotfiles"
DOTFILES_DIR="$HOME/dotfiles"

# ─── Helpers ──────────────────────────────────────────────────────────────────

info()  { printf "\033[1;34m[info]\033[0m  %s\n" "$*"; }
ok()    { printf "\033[1;32m[ok]\033[0m    %s\n" "$*"; }
skip()  { printf "\033[1;33m[skip]\033[0m  %s\n" "$*"; }

installed() { command -v "$1" &> /dev/null; }

# ─── Detect OS & package manager ─────────────────────────────────────────────

if [[ "$OSTYPE" == darwin* ]]; then
  OS="macos"
  if ! installed brew; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  pkg_install()      { brew install "$@"; }
  pkg_install_cask() { brew install --cask --no-quarantine "$@"; }
elif installed pacman; then
  OS="arch"
  pkg_install()      { sudo pacman -S --needed --noconfirm "$@"; }
  pkg_install_cask() { pkg_install "$@"; }
else
  echo "Unsupported OS. This script supports macOS (Homebrew) and Arch Linux (pacman)."
  exit 1
fi

info "Detected OS: $OS"

# Ensure non-standard install paths are available throughout the script
export PATH="$HOME/.local/bin:$HOME/.juliaup/bin:$HOME/google-cloud-sdk/bin:$PATH"

# ─── Shared packages ─────────────────────────────────────────────────────────

info "Installing shared packages..."

pkg_install \
  tmux \
  fzf \
  neovim \
  eza \
  zoxide \
  git \
  stow \
  zsh \
  ripgrep \
  fd \
  bat \
  lazygit \
  htop \
  difftastic \
  zsh-autosuggestions \
  zsh-syntax-highlighting

# ─── OS-specific packages ────────────────────────────────────────────────────

if [[ "$OS" == "macos" ]]; then
  info "Installing macOS-specific packages..."
  pkg_install_cask alacritty
  brew tap nikitabobko/tap 2>/dev/null || true
  pkg_install_cask aerospace
  pkg_install tmuxp
  pkg_install font-hack-nerd-font
  pkg_install gh glab
  pkg_install postgresql@18
  pkg_install cloud-sql-proxy

  # Git Credential Manager
  brew tap microsoft/git 2>/dev/null || true
  pkg_install_cask git-credential-manager-core

elif [[ "$OS" == "arch" ]]; then
  info "Installing Arch-specific packages..."
  pkg_install \
    alacritty \
    gh \
    glab \
    ttf-hack-nerd \
    postgresql \
    postgis

  # tmuxp via pipx
  if ! installed tmuxp; then
    pkg_install python-pipx
    pipx install tmuxp
  fi

  # cloud-sql-proxy (no pacman package, binary download)
  if ! installed cloud-sql-proxy; then
    info "Installing cloud-sql-proxy..."
    mkdir -p "$HOME/.local/bin"
    curl -o "$HOME/.local/bin/cloud-sql-proxy" \
      https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.15.2/cloud-sql-proxy.linux.amd64
    chmod +x "$HOME/.local/bin/cloud-sql-proxy"
    ok "cloud-sql-proxy installed"
  fi
fi

# ─── Dotfiles ────────────────────────────────────────────────────────────────

if [ ! -d "$DOTFILES_DIR" ]; then
  info "Cloning dotfiles..."
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
else
  skip "Dotfiles already cloned at $DOTFILES_DIR"
fi

# Back up existing configs that would conflict with stow
info "Stowing dotfiles..."
cd "$DOTFILES_DIR"

for target in .config/nvim .config/alacritty .config/tmux .config/tmuxp .config/ghostty .tmux.conf .zshrc .gitconfig; do
  real_path="$HOME/$target"
  if [ -e "$real_path" ] && [ ! -L "$real_path" ]; then
    info "Backing up existing $target to ${target}.bak"
    mv "$real_path" "${real_path}.bak"
  fi
done

stow .

ok "Dotfiles stowed"

# ─── Machine-specific configs ─────────────────────────────────────────────────

copy_local() {
  local target="$1" macos_src="$2" arch_src="$3"
  if [ ! -f "$target" ]; then
    if [[ "$OS" == "macos" ]]; then
      cp "$macos_src" "$target"
    elif [[ "$OS" == "arch" ]]; then
      cp "$arch_src" "$target"
    fi
    ok "Created $(basename "$target") for $OS"
  else
    skip "$(basename "$target") already exists"
  fi
}

copy_local "$HOME/.config/alacritty/local.toml" \
  "$DOTFILES_DIR/.config/alacritty/local.toml.macos" \
  "$DOTFILES_DIR/.config/alacritty/local.toml.omarchy"

copy_local "$HOME/.gitconfig.local" \
  "$DOTFILES_DIR/.gitconfig.local.macos" \
  "$DOTFILES_DIR/.gitconfig.local.omarchy"

# ─── Zsh as default shell ────────────────────────────────────────────────────

ZSH_PATH="$(command -v zsh)"
if [ "$SHELL" != "$ZSH_PATH" ]; then
  info "Setting zsh as default shell..."
  chsh -s "$ZSH_PATH"
  ok "Default shell set to zsh"
else
  skip "zsh is already the default shell"
fi

# ─── Oh My Zsh ───────────────────────────────────────────────────────────────

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
  ok "Oh My Zsh installed"
else
  skip "Oh My Zsh already installed"
fi

# ─── NVM ──────────────────────────────────────────────────────────────────────

export NVM_DIR="$HOME/.nvm"

if [ ! -s "$NVM_DIR/nvm.sh" ]; then
  info "Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | PROFILE=/dev/null bash
  ok "nvm installed"
else
  skip "nvm already installed"
fi

# Load nvm for the rest of this script
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install latest LTS Node
if [ -s "$NVM_DIR/nvm.sh" ]; then
  info "Installing Node LTS..."
  nvm install --lts
fi

# ─── pnpm ────────────────────────────────────────────────────────────────────

if ! installed pnpm; then
  info "Installing pnpm..."
  npm install -g pnpm
  ok "pnpm installed"
else
  skip "pnpm already installed"
fi

# ─── Starship prompt ─────────────────────────────────────────────────────────

if ! installed starship; then
  info "Installing Starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
  ok "Starship installed"
else
  skip "Starship already installed"
fi

# ─── Julia (via juliaup) ─────────────────────────────────────────────────────

if ! installed juliaup; then
  info "Installing Julia via juliaup..."
  curl -fsSL https://install.julialang.org | sh -s -- -y
  ok "Julia installed"
else
  skip "juliaup already installed"
fi

# ─── Google Cloud SDK ─────────────────────────────────────────────────────────

if ! installed gcloud; then
  info "Installing Google Cloud SDK..."
  curl https://sdk.cloud.google.com | bash -s -- --disable-prompts --install-dir="$HOME"
  ok "Google Cloud SDK installed (run 'gcloud init' to configure)"
else
  skip "gcloud already installed"
fi

# ─── TPM (Tmux Plugin Manager) ───────────────────────────────────────────────

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  info "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  ok "TPM installed (press prefix + I in tmux to install plugins)"
else
  skip "TPM already installed"
fi

# ─── Done ─────────────────────────────────────────────────────────────────────

echo ""
ok "Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Restart your shell or run: exec zsh"
echo "  2. Open tmux and press Ctrl-s + I to install plugins"
echo "  3. Run 'gcloud init' if you need Google Cloud"
echo "  4. Run 'gh auth login' for GitHub"
echo "  5. Run 'glab auth login' for GitLab"
