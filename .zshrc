# ─── PATH ─────────────────────────────────────────────────────────────────────

export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$PATH
export PATH=$PATH:/usr/local/go/bin
export PATH=$HOME/Apps:$PATH
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# ─── Environment ──────────────────────────────────────────────────────────────

export EDITOR=nvim
export DISABLE_AUTO_TITLE='true'
set -o vi

# GCM credential store (macOS only)
if command -v git-credential-manager &> /dev/null; then
  export GCM_CREDENTIAL_STORE=keychain
fi

# ─── Oh My Zsh ────────────────────────────────────────────────────────────────

export ZSH=$HOME/.oh-my-zsh
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
ZSH_THEME="robbyrussell"
DISABLE_UPDATE_PROMPT="true"

plugins=(git npm yarn kubectl gcloud docker eza)

source $ZSH/oh-my-zsh.sh
eval "$(starship init zsh)"

# ─── Aliases ──────────────────────────────────────────────────────────────────

if type nvim > /dev/null 2>&1; then
  alias vim='nvim'
fi

alias reload='echo "Reload ~/.zshrc" && source ~/.zshrc'
alias cl='clear'
alias gci='git commit'
alias gitst='git status'
alias gdt='git difftool'
alias glgt='f() { GIT_EXTERNAL_DIFF=difft git log -p --ext-diff "$@"; }; f'
alias gsht='f() { GIT_EXTERNAL_DIFF=difft git show "$@" --ext-diff; }; f'

alias ta='tmux attach -t'
alias tad='tmux attach -d -t'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'
alias tkss='tmux kill-session -t'
alias tksv='tmux kill-server'

alias update-julia-dev='find ~/.julia/dev -type d -name .git -execdir git pull \;'

# ─── Tool setup ───────────────────────────────────────────────────────────────

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# pnpm
if command -v pnpm &> /dev/null; then
  eval "$(pnpm completion zsh)"
fi

# juliaup
if [ -d "$HOME/.juliaup/bin" ]; then
  path=("$HOME/.juliaup/bin" $path)
  export PATH
fi

# zoxide
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh --cmd cd)"
fi

# gcloud
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# PostgreSQL (homebrew)
if [ -d "/opt/homebrew/opt/postgresql@18/bin" ]; then
  export PATH="/opt/homebrew/opt/postgresql@18/bin:$PATH"
fi

# ─── Zsh plugins (sourced after oh-my-zsh) ───────────────────────────────────

if [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
