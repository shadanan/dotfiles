# Disable Oh My Zsh auto update
DISABLE_AUTO_UPDATE=true

# Source shared environment
source ~/.sharedrc

# Source local zsh environment
if [ -f "$HOME/.zshenv" ]; then
	source "$HOME/.zshenv"
fi

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

# Configure pyenv
export PYENV_ROOT=/usr/local/var/pyenv
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
if which pyenv > /dev/null 2>&1; then eval "$(pyenv init -)"; fi
if which pyenv-virtualenv-init > /dev/null 2>&1; then eval "$(pyenv virtualenv-init -)"; fi

# Source local shared environment
if [ -f "$HOME/.sharedenv" ]; then
	source "$HOME/.sharedenv"
fi
