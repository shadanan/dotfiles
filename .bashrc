# Source shared environment
if [ -f "$HOME/.environment" ]; then
  source "$HOME/.environment"
fi

# Source global bash environment
if [ -f /etc/bashrc ]; then 
  source /etc/bashrc
fi

PS1='\[\033[01;36m\]\u\[\033[00m\]@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \[\033[01;37m\]\$\[\033[00m\] '
