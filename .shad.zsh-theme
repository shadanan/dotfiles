ZSH_GIT_PROMPT_SHOW_UPSTREAM="yes"
ZSH_GIT_PROMPT_SHOW_STASH=1
ZSH_THEME_GIT_PROMPT_PREFIX="["
ZSH_THEME_GIT_PROMPT_SUFFIX="] "
ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
ZSH_THEME_GIT_PROMPT_DETACHED="%{$fg_bold[cyan]%}:"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_UPSTREAM_SYMBOL="%{$fg_bold[yellow]%}⟳ "
ZSH_THEME_GIT_PROMPT_UPSTREAM_PREFIX="%{$fg[red]%}(%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_UPSTREAM_SUFFIX="%{$fg[red]%})"
ZSH_THEME_GIT_PROMPT_BEHIND="↓"
ZSH_THEME_GIT_PROMPT_AHEAD="↑"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[blue]%}●"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg[red]%}✚"
ZSH_THEME_GIT_PROMPT_UNTRACKED="…"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[blue]%}⚑"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✔"

function exit_status {
	local retval=$?
	if [ $retval -eq 0 ]; then 
		echo "%{$fg_bold[green]%}✔%{$reset_color%}"
	elif [ $retval -eq $SIGINT ]; then
		echo "%{$fg_bold[yellow]%}⏹%{$reset_color%}"
	elif [ $retval -eq $SIGTSTP ]; then
		echo "%{$fg_bold[yellow]%}⏸%{$reset_color%}"
	else
		echo "%{$fg_bold[red]%}✗%{$reset_color%}"
	fi
}

function host {
	echo "%{$fg_bold[cyan]%}%n%{$reset_color%}@%{$fg_bold[green]%}%m%{$reset_color%}"
}

function path {
	echo "%{$fg_bold[blue]%}%~%{$reset_color%}"
}

function timestamp {
	echo "%{$fg_bold[black]%}%D{%Y-%m-%d %H:%M:%S}%{$reset_color%}"
}

function history_index {
	echo "%{$fg[yellow]%}%!%{$reset_color%}"
}

function prompt_char {
	if [ $UID -eq 0 ]; then 
		echo "%{$fg[red]%}#%{$reset_color%}"
	else
		echo "%{$fg_bold[white]%}$%{$reset_color%}"
	fi
}

function ruby_name {
	if ! [ -z "$RUBY_ENGINE" ]; then
		echo "%{$fg[red]%}${RUBY_ENGINE##*/}-${RUBY_VERSION##*/}%{$reset_color%}|"
	fi
}

function venv_name {
	if ! [ -z "$VIRTUAL_ENV" ]; then
		echo "%{$fg[red]%}${VIRTUAL_ENV##*/}%{$reset_color%}|"
	fi
}

function conda_name {
	if ! [ -z "$CONDA_DEFAULT_ENV" ]; then
		echo "%{$fg[red]%}${CONDA_DEFAULT_ENV##*/}%{$reset_color%}|"
	fi
}

function arch_name {
	if [ -x "$(command -v arch)" ]; then
		echo "%{$fg[cyan]%}$(arch)%{$reset_color%}|"
	fi
}

function tool_status {
	echo "$(ruby_name)$(venv_name)$(conda_name)$(arch_name)"
}

if [[ "$BASIC_PROMPT" == "true" ]]; then
	PROMPT="$(path) $(prompt_char) "
	return
fi

PROMPT='$(exit_status) $(host):$(path) $(gitprompt)
$(timestamp) [$(tool_status)$(history_index)] $(prompt_char) '
