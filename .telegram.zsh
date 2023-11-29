telegram() {
  if [ -n "$TELEGRAM_TOKEN" ] && [ -n "$TELEGRAM_CHAT_ID" ]; then
    (
      curl -s \
        -X POST \
        -d "chat_id=$TELEGRAM_CHAT_ID" \
        -d parse_mode="MarkdownV2" \
        -d "text=$2 __$(whoami)@$(hostname -s)__ \\- $1" \
        https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage & \
    ) > /dev/null 2>&1
  fi
}

telegram_is_long_running() {
  # Pop sudo and its arguments
  if [[ $1 == "sudo" ]]; then
    shift
    local args=(
      -C -D -g -h --host -p --prompt -R --chroot -T --command-timeout -u --user -U 
      --other-user
    )
    while [[ $1 == -* ]]; do
      if (( ${args[(Ie)$1]} )); then
        shift
      fi
      shift
    done
  fi

  # Pop environment variables
  while [[ $1 =~ "[A-Za-z_][A-Za-z0-9_]=.*" ]]; do
    shift
  done

  local cmd=($@)
  local cmds=(
    bash functions-framework groovysh htop man sh ssh streamlit tmux top vim zsh
  )
  if (( ${cmds[(Ie)$1]} )); then
    return 0
  elif (( ${cmd[(Ie)less]} )); then
    return 0
  elif [[ $1 == "cargo" ]]; then
    if (( ${cmd[(Ie)dev]} )); then
      return 0
    fi
  elif [[ $1 == "git" ]]; then
    local subcmds=(commit dag diff log)
    if (( ${subcmds[(Ie)$2]} )); then
      return 0
    fi
  elif [[ $1 == "kubectl" ]]; then
    if (( ${cmd[(Ie)port-forward]} )); then
      return 0
    fi
  elif [[ $1 == "tsh" ]]; then
    local subcmds=(ssh)
    if (( ${subcmds[(Ie)$2]} )); then
      return 0
    fi
  fi

  return 1
}

# Store the command to be executed in a global variable
telegram_preexec_notify() {
  telegram_notify_cmd=$1
}

# Notify telegram on long running commands
telegram_precmd_notify() {
  # Store the exit status of the last command
  local retval=$?

  # Ignore if the command is empty
  if [ -z "$telegram_notify_cmd" ]; then 
    return 0
  fi
  unset telegram_notify_cmd

  # Don't notify if status is in ignore list
  local ignore=($SIGINT $SIGTSTP)
  if (( ${ignore[(Ie)$retval]} )); then
    return 0
  fi

  # Get the last command and its duration
  local -a stats=( $(fc -Dl -1) )

  # Ignore commands that are expected to be long running
  if telegram_is_long_running ${stats[3,-1]}; then
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
    local emoji=$([ $retval -ne 0 ] && echo "❌" || echo "✅")
    local msg="*${stats[2]}* \[${retval}\] \\- \`${stats[3,-1]}\`"
    telegram "$msg" "$emoji"
  fi

  return 0
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec telegram_preexec_notify
add-zsh-hook precmd telegram_precmd_notify
