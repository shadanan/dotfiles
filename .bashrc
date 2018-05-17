# .bashrc

# Source shared environment
source ~/.sharedrc

# Source global bash environment
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Enable homebrew bash completion
if hash brew 2> /dev/null; then
	if [ -f $(brew --prefix)/share/bash-completion/bash_completion ]; then
		. $(brew --prefix)/share/bash-completion/bash_completion
	fi
fi

# Bash history fixes
shopt -s histappend
export HISTSIZE=5000

if [ -z "$HISTFILE" ]; then
	export HISTFILE="$HOME/.bash_history"
fi

# User specific aliases and functions
export GREP_OPTIONS='--color=auto'

unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
	alias ls='ls --color=auto'
elif [[ "$unamestr" == 'FreeBSD' ]]; then
	alias ls='ls -G'
elif [[ "$unamestr" == 'Darwin' ]]; then
	export CLICOLOR=1
fi

export PROMPT_COMMAND='history -a'

__GIT_PROMPT_DIR="$HOME/.bash-git-prompt"
. "$__GIT_PROMPT_DIR/prompt-colors.sh"
GIT_PROMPT_BRANCH="${BoldMagenta}"
GIT_PROMPT_CONFLICTS="${Red}✖"
GIT_PROMPT_CHANGED="${Blue}✚"
GIT_PROMPT_STASHED="${BoldBlue}⚑"
GIT_PROMPT_START="$Magenta\u$ResetColor@$Yellow\h$ResetColor:$BoldBlue\w$ResetColor"
GIT_PROMPT_END="\n$Green\D{%F %T}$ResetColor [$BoldYellow\!$ResetColor] $ "
. "$__GIT_PROMPT_DIR/gitprompt.sh"

# Enable command-line fuzzy finder (https://github.com/junegunn/fzf)
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Source local shared environment
if [ -f "$HOME/.sharedenv" ]; then
	source "$HOME/.sharedenv"
fi

# Source local bash environment
if [ -f "$HOME/.bashenv" ]; then
	source "$HOME/.bashenv"
fi
