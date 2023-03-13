# Disable Oh My Zsh auto update
DISABLE_AUTO_UPDATE=true

# Ignore insecure completion-dependent directories
ZSH_DISABLE_COMPFIX=true

# Disable magic functions so that URLs paste properly
DISABLE_MAGIC_FUNCTIONS=true

# Set history file
export HISTFILE=~/.zsh_history

# Source shared environment
source ~/.sharedrc

# Configure history
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt histIgnoreSpace

# gcloud
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

# 1password cli zsh completion
if [ -x "$(command -v op)" ]; then
  eval "$(op completion zsh)"; compdef _op op
fi

# Activate Shad's zsh git prompt
source "$HOME/.zsh-git-prompt/git-prompt.zsh"

# Path to oh-my-zsh installation
export ZSH=$HOME/.oh-my-zsh

# Set oh-my-zsh theme
ZSH_THEME="shad"

if [ $(zsh --version | cut -d' ' -f2 | cut -d'.' -f1) -gt "4" ]; then
	plugins+=(zsh-syntax-highlighting)
fi

# Activate oh-my-zsh
source $ZSH/oh-my-zsh.sh

notify() {
  local exit_code=$?
  local -a stats=( $(fc -Dl -1) )

  local -a time=( "${(s.:.)stats[2]}" )
  local -i seconds=0 mult=1
  while (( $#time[@] )); do
    (( seconds += mult * time[-1] ))
    (( mult *= 60 ))
    shift -p time
  done

  local user=$(whoami)
  local host=$(hostname)
  local cmd=$stats[3,-1]
  local message=""
  if [[ $exit_code -ne 0 ]]; then
    message+="❌ Command failed"
  else
    message+="✅ Command succeeded"
  fi
  message+=" after $stats[2] on \`$user@$host\`:
\`\`\`shell
$cmd
\`\`\`"

  if (( seconds >= 120 )) && [ -n "$TELEGRAM_TOKEN" ] && [ -n "$TELEGRAM_CHAT_ID" ]; then
    curl -s \
      -X POST \
      -d chat_id="$TELEGRAM_CHAT_ID" \
      -d parse_mode="MarkdownV2" \
      -d text="$message" \
      "https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage" \
      > /dev/null
  fi

  return 0
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd notify

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
