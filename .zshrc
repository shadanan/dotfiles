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

# Store the command to be executed in a global variable
telegram_preexec_notify() {
  telegram_notify_cmd=$1
}

# Notify telegram on long running commands
telegram_precmd_notify() {
  # Ignore if the command is empty
  if [ -z "$telegram_notify_cmd" ]; then 
    return 0
  fi
  unset telegram_notify_cmd

  # Store the exit status of the last command
  local exit_status=$?
  local -a stats=( $(fc -Dl -1) )

  # Ignore commands that are interactive
  local interactive=(git htop less man screen ssh tmux top vim)
  if (( ${interactive[(Ie)$stats[3]]} )); then
    return 0
  fi

  # Calculate the duration of the last command
  local -a time=( "${(s.:.)stats[2]}" )
  local -i seconds=0 mult=1
  while (( $#time[@] )); do
    (( seconds += mult * time[-1] ))
    (( mult *= 60 ))
    shift -p time
  done

  # Notify if the command took longer than 2 minutes
  if (( seconds >= 120 )); then
    local emoji=$([ $exit_status -ne 0 ] && echo "❌" || echo "✅")
    local msg="*${stats[2]}* \\- \`${stats[3,-1]}\`"
    telegram "$emoji" "$msg"
  fi

  return 0
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec telegram_preexec_notify
add-zsh-hook precmd telegram_precmd_notify

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
