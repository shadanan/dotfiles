# Set variables for prompt
(( SIGINT = 128 + $(kill -l INT) ))
(( SIGTSTP = 128 + $(kill -l TSTP) ))

# Set history file
export HISTFILE=~/.zsh_history

# Source shared environment
source ~/.sharedrc

# Configure history
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt histIgnoreSpace

# Enable tab highlighting
zstyle ':completion:*' menu select

# Up and down arrow search
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "$terminfo[kcuu1]" history-beginning-search-backward-end
bindkey "^[[B" down-line-or-beginning-search # Down
bindkey "$terminfo[kcud1]" history-beginning-search-forward-end

# gcloud zsh completion
if [ -x "$(command -v brew)" ]; then
    if [ -f "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc" ]; then
        source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
    fi
fi

# Homebrew zsh completion
if [ -x "$(command -v brew)" ]; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
  autoload -Uz compinit
  compinit -u
fi

# Activate Shad's zsh git prompt
source "$HOME/.zsh-git-prompt/git-prompt.zsh"
source "$HOME/.shad.zsh-theme"

# Activate zsh syntax highlighting
source "$HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Python virtual environment
source $HOME/.venv.zsh

# Telegram notifier
source $HOME/.telegram.zsh

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
