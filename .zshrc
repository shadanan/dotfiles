# Disable Oh My Zsh auto update
DISABLE_AUTO_UPDATE=true

# Ignore insecure completion-dependent directories
ZSH_DISABLE_COMPFIX=true

# Source shared environment
source ~/.sharedrc

# Activate shad's zsh git prompt
source "$HOME/.zsh-git-prompt/zshrc.sh"

# Path to oh-my-zsh installation
export ZSH=$HOME/.oh-my-zsh

# Set oh-my-zsh theme
ZSH_THEME="shad"

# Set oh-my-zsh plugins
plugins=(z)

if [ $(zsh --version | cut -d' ' -f2 | cut -d'.' -f1) -gt "4" ]; then
	plugins+=(zsh-syntax-highlighting)
fi

# Activate oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# Configure venv
export VIRTUAL_ENV_DISABLE_PROMPT=0

# Enable command-line fuzzy finder (https://github.com/junegunn/fzf)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Source local shared environment
if [ -f "$HOME/.sharedenv" ]; then
	source "$HOME/.sharedenv"
fi

# Source local zsh environment
if [ -f "$HOME/.zshenv" ]; then
	source "$HOME/.zshenv"
fi
