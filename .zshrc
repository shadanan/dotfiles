# Source shared environment
if [ -f "$HOME/.environment" ]; then
	source "$HOME/.environment"
fi

# Source shared config
if [ -f "$HOME/.sharedrc" ]; then
  source ~/.sharedrc
fi

# Set variables for prompt
(( SIGINT = 128 + $(kill -l INT) ))
(( SIGTSTP = 128 + $(kill -l TSTP) ))

# Configure history
export HISTFILE=~/.zsh_history
export SAVEHIST=1000000
export HISTSIZE=1000000
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY

# Enable tab highlighting
zstyle ':completion:*' menu select

# Up and down arrow search
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
bindkey "${terminfo[kcud1]}" down-line-or-beginning-search

# gcloud zsh completion
if [ -x "$(command -v brew)" ]; then
  if [ -f "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc" ]; then
    source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
  fi
fi

# Custom shell functions
if [ -d "$HOME/.zfunc" ]; then
  FPATH="$HOME/.zfunc:${FPATH}"
  autoload -Uz compinit && compinit -u
fi

# Homebrew zsh completion
if [ -x "$(command -v brew)" ]; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
  autoload -Uz compinit && compinit -u
fi

# Activate Shad's zsh git prompt
source "$HOME/.zsh-git-prompt/git-prompt.zsh"
source "$HOME/.shad.zsh-theme"

# Activate zsh syntax highlighting
source "$HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Configure venv
export VIRTUAL_ENV_DISABLE_PROMPT=0

# Enable command-line fuzzy finder (https://github.com/junegunn/fzf)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -d ~/.fzf-git.sh ] && source ~/.fzf-git.sh/fzf-git.sh
