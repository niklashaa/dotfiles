# zmodload zsh/zprof # Start profiling

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:/usr/local/go/bin
export PATH=$HOME/Apps:$PATH

export GCM_CREDENTIAL_STORE=keychain
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# https://stackoverflow.com/questions/62931101/i-have-multiple-files-of-zcompdump-why-do-i-have-multiple-files-of-these
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST
export EDITOR=nvim

set -o vi

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Use pyenv for python version
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Use neovim as default
if type nvim > /dev/null 2>&1; then
  alias vim='nvim'
fi

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

plugins=(
  git
  npm
  yarn
  kubectl
  gcloud
  zsh-autosuggestions
  docker
  eza
)

source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"
# User configuration

# Always stay in tmux
# _not_inside_tmux() { [[ -z "$TMUX" ]] }

# ensure_tmux_is_running() {
#   if _not_inside_tmux; then
#     tat
#   fi
# }
# ensure_tmux_is_running

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias reload='echo "Reload ~/.zshrc" && source ~/.zshrc'
alias cl='clear'
alias gci='git commit'
alias gitst='git status'
alias gdt='git difftool'
alias glgt='f() { GIT_EXTERNAL_DIFF=difft git log -p --ext-diff "$@"; }; f'
alias gsht='f() { GIT_EXTERNAL_DIFF=difft git show "$@" --ext-diff; }; f'

export DISABLE_AUTO_TITLE='true'

alias ta='tmux attach -t'
alias tad='tmux attach -d -t'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'
alias tkss='tmux kill-session -t'
alias tksv='tmux kill-server'

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
 eval "$(pyenv init -)"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

## Gcloud setup
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/niklashaag/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/niklashaag/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/niklashaag/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/niklashaag/google-cloud-sdk/completion.zsh.inc'; fi

export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
# zprof # Stop profiling

# >>> juliaup initialize >>>
# !! Contents within this block are managed by juliaup !!
path=('/Users/niklashaag/.juliaup/bin' $path)
export PATH
alias update-julia-dev='find ~/.julia/dev -type d -name .git -execdir git pull \;'

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# bun completions
[ -s "/Users/niklashaag/.bun/_bun" ] && source "/Users/niklashaag/.bun/_bun"
# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

alias claude="/Users/niklashaag/.claude/local/claude"

if command -v zoxide &> /dev/null; then
    export ZOXIDE_CMD_OVERRIDE="cd"
    eval "$(zoxide init zsh)"
fi
