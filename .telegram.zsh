telegram() {
  if [ -n "$TELEGRAM_TOKEN" ] && [ -n "$TELEGRAM_CHAT_ID" ]; then
    (
      local sig="__$(whoami | telegram_escape)@$(hostname -s | telegram_escape)__ \\-"
      curl -s \
        -X POST \
        -d chat_id="$TELEGRAM_CHAT_ID" \
        -d parse_mode="MarkdownV2" \
        -d text="$2 $sig $1" \
        https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage \
    )
  fi
}

telegram_escape() {
  sed -E 's/([][_*()~`>#+-=|{}.!])/\\\1/g'
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

  # Override conditional notification if env var is set
  local notify_override=$(( ${stats[3,-1][(Ie)TELEGRAM_NOTIFY=1]} ? 1 : 0 ))

  # Calculate the duration of the last command
  local -a time=( "${(s.:.)stats[2]}" )
  local -i elapsed=0 mult=1
  while (( $#time[@] )); do
    (( elapsed += mult * time[-1] ))
    (( mult *= 60 ))
    shift -p time
  done

  # Ignore commands that took less than 30 seconds
  if (( !notify_override && elapsed < 30 )); then
    return 0
  fi

  # Calculate the user idle time
  local -i idle=0
  if [ -x "$(command -v ioreg)" ]; then
    idle=$(ioreg -c IOHIDSystem | awk '/HIDIdleTime/ {print $NF/1000000000; exit}')
  fi

  # Ignore commands if the user was idle for less than 30 seconds
  if (( !notify_override && idle < 30 )); then
    return 0
  fi

  local emoji=$([ $retval -ne 0 ] && echo "❌" || echo "✅")
  local msg="*${stats[2]}* \[${retval}\] \\- \`${stats[3,-1]}\`"
  (telegram "$msg" "$emoji" &) > /dev/null 2>&1
  return 0
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec telegram_preexec_notify
add-zsh-hook precmd telegram_precmd_notify
