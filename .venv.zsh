python_venv_auto_autoactivate() {
  if [ -d ".venv" ]; then
    source .venv/bin/activate
  elif (( ${+VIRTUAL_ENV} )); then
    deactivate
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd python_venv_auto_autoactivate
