# Source shared aliases
source ~/.sharedrc

if [ -f "$HOME/.zshenv" ]; then
	source "$HOME/.zshenv"
fi

# Load antigen
source ~/.antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
if which pip > /dev/null 2>&1; then antigen bundle pip; fi
#antigen bundle vagrant

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Git super status
antigen bundle shadanan/zsh-git-prompt

# Load the theme.
antigen theme shadanan/oh-my-zsh-themes shad

# Tell antigen that you're done.
antigen apply

# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# Configure pyenv
export PYENV_ROOT=/usr/local/var/pyenv
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
if which pyenv > /dev/null 2>&1; then eval "$(pyenv init -)"; fi
if which pyenv-virtualenv-init > /dev/null 2>&1; then eval "$(pyenv virtualenv-init -)"; fi
