# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/google/home/shads/Downloads/fzf-master/bin* ]]; then
  export PATH="$PATH:/usr/local/google/home/shads/Downloads/fzf-master/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/local/google/home/shads/Downloads/fzf-master/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/usr/local/google/home/shads/Downloads/fzf-master/shell/key-bindings.zsh"

