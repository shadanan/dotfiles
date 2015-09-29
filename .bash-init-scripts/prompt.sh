#!/usr/bin/env sh

# Git/Subversion prompt function
function __git_svn_ps1() {
  echo -n "$(__svn_ps1)$(__git_ps1)"
}

function __git_prompt_dir() {
  # assume the gitstatus.py is in the same directory as this script
  # code thanks to http://stackoverflow.com/questions/59895
  if [ -z "${__GIT_PROMPT_DIR}" ]; then
    local SOURCE="${BASH_SOURCE[0]}"
    while [ -h "${SOURCE}" ]; do
      local DIR="$( cd -P "$( dirname "${SOURCE}" )" && pwd )"
      SOURCE="$(readlink "${SOURCE}")"
      [[ $SOURCE != /* ]] && SOURCE="${DIR}/${SOURCE}"
    done
    __GIT_PROMPT_DIR="$( cd -P "$( dirname "${SOURCE}" )" && pwd )"
  fi
}

function __git_prompt_config() {
  # Default values for the appearance of the prompt. Configure at will.
  GIT_PROMPT_PREFIX="${BIWhite}[${ResetColor}"
  GIT_PROMPT_SUFFIX="${BIWhite}]${ResetColor}"
  GIT_PROMPT_SEPARATOR="${BIWhite}|${ResetColor}"
  GIT_PROMPT_BRANCH="${BIGreen}"
  GIT_PROMPT_STAGED="${BIYellow}●"
  GIT_PROMPT_CONFLICTS="${BIRed}✖"
  GIT_PROMPT_CHANGED="${BIGreen}✚"
  GIT_PROMPT_REMOTE=" "
  GIT_PROMPT_UNTRACKED="${BICyan}…"
  GIT_PROMPT_CLEAN="${BIGreen}✔"

  # fetch remote revisions every other $GIT_PROMPT_FETCH_TIMEOUT (default 5) minutes
  GIT_PROMPT_FETCH_TIMEOUT=${1-5}
  if [ "x$__GIT_STATUS_CMD" == "x" ]
  then
    __git_prompt_dir
    __GIT_STATUS_CMD="${__GIT_PROMPT_DIR}/gitstatus.py"
  fi
}

function __git_ps1() {
  local GIT_PROMPT_PREFIX
  local GIT_PROMPT_SUFFIX
  local GIT_PROMPT_SEPARATOR
  local GIT_PROMPT_BRANCH
  local GIT_PROMPT_STAGED
  local GIT_PROMPT_CONFLICTS
  local GIT_PROMPT_CHANGED
  local GIT_PROMPT_REMOTE
  local GIT_PROMPT_UNTRACKED
  local GIT_PROMPT_CLEAN
  local PROMPT_START
  local PROMPT_END
  local EMPTY_PROMPT
  local ResetColor
  local Blue
  local GIT_PROMPT_FETCH_TIMEOUT
  local __GIT_STATUS_CMD

  __git_prompt_config

  local -a GitStatus
  GitStatus=($("${__GIT_STATUS_CMD}" 2>/dev/null))

  local GIT_BRANCH=${GitStatus[0]}
  local GIT_REMOTE=${GitStatus[1]}
  if [[ "." == "$GIT_REMOTE" ]]; then
    unset GIT_REMOTE
  fi
  local GIT_STAGED=${GitStatus[2]}
  local GIT_CONFLICTS=${GitStatus[3]}
  local GIT_CHANGED=${GitStatus[4]}
  local GIT_UNTRACKED=${GitStatus[5]}
  local GIT_CLEAN=${GitStatus[6]}

  if [[ -n "${GitStatus}" ]]; then
    local STATUS=" ${GIT_PROMPT_PREFIX}${GIT_PROMPT_BRANCH}${GIT_BRANCH}${ResetColor}"

    if [[ -n "${GIT_REMOTE}" ]]; then
      STATUS="${STATUS}${GIT_PROMPT_REMOTE}${GIT_REMOTE}${ResetColor}"
    fi

    STATUS="${STATUS}${GIT_PROMPT_SEPARATOR}"
    if [ "${GIT_STAGED}" -ne "0" ]; then
      STATUS="${STATUS}${GIT_PROMPT_STAGED}${GIT_STAGED}${ResetColor}"
    fi

    if [ "${GIT_CONFLICTS}" -ne "0" ]; then
      STATUS="${STATUS}${GIT_PROMPT_CONFLICTS}${GIT_CONFLICTS}${ResetColor}"
    fi

    if [ "${GIT_CHANGED}" -ne "0" ]; then
      STATUS="${STATUS}${GIT_PROMPT_CHANGED}${GIT_CHANGED}${ResetColor}"
    fi

    if [ "${GIT_UNTRACKED}" -ne "0" ]; then
      STATUS="${STATUS}${GIT_PROMPT_UNTRACKED}${GIT_UNTRACKED}${ResetColor}"
    fi

    if [ "${GIT_CLEAN}" -eq "1" ]; then
      STATUS="${STATUS}${GIT_PROMPT_CLEAN}"
    fi

    STATUS="${STATUS}${ResetColor}${GIT_PROMPT_SUFFIX}"

    echo "${STATUS}"

    if [[ -n "${VIRTUAL_ENV}" ]]; then
      echo "${Blue}($(basename "${VIRTUAL_ENV}"))${ResetColor} ${PS1}"
    fi

  else
    echo ""
  fi
}

# Outputs the current trunk, branch, or tag
# Subversion prompt function
__svn_ps1() {
  local SVN_PROMPT_SEPARATOR="${BIWhite}|${ResetColor}"
  local SVN_PROMPT_ADDED="${BIYellow}✚"
  local SVN_PROMPT_MODIFIED="${BIYellow}●"
  local SVN_PROMPT_DELETED="${BIYellow}-"
  local SVN_PROMPT_CONFLICTS="${BIRed}✖"
  local SVN_PROMPT_MISSING="${BIRed}!"
  local SVN_PROMPT_UNTRACKED="${BICyan}…"
  local SVN_PROMPT_CLEAN="${BIGreen}✔"

  local svninfo=$(svn info 2> /dev/null)
  
  if [ -n "$svninfo" ]; then
    local revision=$(echo "$svninfo" | awk '/Revision:/ {print $2}')
    local SVN_STATUS=$(svn status | grep '^\s*[?ACDMR?!]')
    
    local STATUS="${SVN_PROMPT_CLEAN}${ResetColor}"

    if [[ -n "${SVN_STATUS}" ]]; then
      local SVN_CONFLICTS=$(echo "$SVN_STATUS" | grep '^C' | wc -l | tr -d ' ')
      local SVN_ADDED=$(echo "$SVN_STATUS" | grep '^A' | wc -l | tr -d ' ')
      local SVN_MODIFIED=$(echo "$SVN_STATUS" | grep '^M' | wc -l | tr -d ' ')
      local SVN_DELETED=$(echo "$SVN_STATUS" | grep '^D' | wc -l | tr -d ' ')
      local SVN_MISSING=$(echo "$SVN_STATUS" | grep '^!' | wc -l | tr -d ' ')
      local SVN_UNTRACKED=$(echo "$SVN_STATUS" | grep '^?' | wc -l | tr -d ' ')

      STATUS=""
      if [ "${SVN_ADDED}" -ne "0" ]; then
        STATUS="${STATUS}${SVN_PROMPT_ADDED}${SVN_ADDED}${ResetColor}"
      fi

      if [ "${SVN_MODIFIED}" -ne "0" ]; then
        STATUS="${STATUS}${SVN_PROMPT_MODIFIED}${SVN_MODIFIED}${ResetColor}"
      fi

      if [ "${SVN_DELETED}" -ne "0" ]; then
        STATUS="${STATUS}${SVN_PROMPT_DELETED}${SVN_DELETED}${ResetColor}"
      fi

      if [ "${SVN_MISSING}" -ne "0" ]; then
        STATUS="${STATUS}${SVN_PROMPT_MISSING}${SVN_MISSING}${ResetColor}"
      fi

      if [ "${SVN_CONFLICTS}" -ne "0" ]; then
        STATUS="${STATUS}${SVN_PROMPT_CONFLICTS}${SVN_CONFLICTS}${ResetColor}"
      fi

      if [ "${SVN_UNTRACKED}" -ne "0" ]; then
        STATUS="${STATUS}${SVN_PROMPT_UNTRACKED}${SVN_UNTRACKED}${ResetColor}"
      fi
    fi

    local s=" [${BIGreen}${revision}${ResetColor}${SVN_PROMPT_SEPARATOR}${STATUS}]"
    echo -n "$s"
  fi
}
