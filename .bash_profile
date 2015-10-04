# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
