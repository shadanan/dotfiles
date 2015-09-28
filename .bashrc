# .bashrc

# Colours

# Reset
export Color_Off="\[\033[0m\]"       # Text Reset
export ResetColor="\[\033[0m\]"      # Text Reset

# Regular Colors
export Black="\[\033[0;30m\]"        # Black
export Red="\[\033[0;31m\]"          # Red
export Green="\[\033[0;32m\]"        # Green
export Yellow="\[\033[0;33m\]"       # Yellow
export Blue="\[\033[0;34m\]"         # Blue
export Purple="\[\033[0;35m\]"       # Purple
export Cyan="\[\033[0;36m\]"         # Cyan
export White="\[\033[0;37m\]"        # White

# Bold
export BBlack="\[\033[1;30m\]"       # Black
export BRed="\[\033[1;31m\]"         # Red
export BGreen="\[\033[1;32m\]"       # Green
export BYellow="\[\033[1;33m\]"      # Yellow
export BBlue="\[\033[1;34m\]"        # Blue
export BPurple="\[\033[1;35m\]"      # Purple
export BCyan="\[\033[1;36m\]"        # Cyan
export BWhite="\[\033[1;37m\]"       # White

# Underline
export UBlack="\[\033[4;30m\]"       # Black
export URed="\[\033[4;31m\]"         # Red
export UGreen="\[\033[4;32m\]"       # Green
export UYellow="\[\033[4;33m\]"      # Yellow
export UBlue="\[\033[4;34m\]"        # Blue
export UPurple="\[\033[4;35m\]"      # Purple
export UCyan="\[\033[4;36m\]"        # Cyan
export UWhite="\[\033[4;37m\]"       # White

# Background
export On_Black="\[\033[40m\]"       # Black
export On_Red="\[\033[41m\]"         # Red
export On_Green="\[\033[42m\]"       # Green
export On_Yellow="\[\033[43m\]"      # Yellow
export On_Blue="\[\033[44m\]"        # Blue
export On_Purple="\[\033[45m\]"      # Purple
export On_Cyan="\[\033[46m\]"        # Cyan
export On_White="\[\033[47m\]"       # White

# High Intensty
export IBlack="\[\033[0;90m\]"       # Black
export IRed="\[\033[0;91m\]"         # Red
export IGreen="\[\033[0;92m\]"       # Green
export IYellow="\[\033[0;93m\]"      # Yellow
export IBlue="\[\033[0;94m\]"        # Blue
export IPurple="\[\033[0;95m\]"      # Purple
export ICyan="\[\033[0;96m\]"        # Cyan
export IWhite="\[\033[0;97m\]"       # White

# Bold High Intensty
export BIBlack="\[\033[1;90m\]"      # Black
export BIRed="\[\033[1;91m\]"        # Red
export BIGreen="\[\033[1;92m\]"      # Green
export BIYellow="\[\033[1;93m\]"     # Yellow
export BIBlue="\[\033[1;94m\]"       # Blue
export BIPurple="\[\033[1;95m\]"     # Purple
export BICyan="\[\033[1;96m\]"       # Cyan
export BIWhite="\[\033[1;97m\]"      # White

# High Intensty backgrounds
export On_IBlack="\[\033[0;100m\]"   # Black
export On_IRed="\[\033[0;101m\]"     # Red
export On_IGreen="\[\033[0;102m\]"   # Green
export On_IYellow="\[\033[0;103m\]"  # Yellow
export On_IBlue="\[\033[0;104m\]"    # Blue
export On_IPurple="\[\033[10;95m\]"  # Purple
export On_ICyan="\[\033[0;106m\]"    # Cyan
export On_IWhite="\[\033[0;107m\]"   # White


# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment and startup programs
if [ -d "$HOME/.local/bin" ]; then
	export PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.local/lib" ]; then
	export LD_LIBRARY_PATH="$HOME/.local/lib:$LD_LIBRARY_PATH"
fi

if [ -f /usr/libexec/java_home ]; then
	export JAVA_HOME=`/usr/libexec/java_home`
fi

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

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# User specific aliases and functions
export EDITOR=vim
export GREP_OPTIONS='--color=auto'

unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
	alias ls='ls --color=auto'
elif [[ "$unamestr" == 'FreeBSD' ]]; then
	alias ls='ls -G'
elif [[ "$unamestr" == 'Darwin' ]]; then
	export CLICOLOR=1
fi

function set_ps1 {
	export PS1="$Purple\u$Color_Off@$Yellow\h$Color_Off:$BBlue\w$Color_Off"
	export PS1="$PS1\n$Green\D{%F %T}$Color_Off [$IYellow\!$Color_Off] $ "
}

export PROMPT_COMMAND='history -a;set_ps1'
