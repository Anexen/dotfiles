#!/usr/bin/env bash


__generate_ps1() {
  local environ=""

  if [[ -n "${VIRTUAL_ENV}" ]]; then
    environ="("$(basename "${VIRTUAL_ENV}")")"
  fi

  local time="${PIGreen}[\t]${PColorOff}"
  local shell="${PIBlue} \u@\h:${PColorOff}"
  local wd="${PGreen}\w${PColorOff}"
  local scm="${PYellow}$(__git_ps1)${PColorOff}"
  local greet="\n${PIGreen}└─ \$${PColorOff} "

  PS1="${environ}${time}${shell}${wd}${scm}${greet}"
}

PROMPT_COMMAND=__generate_ps1

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

__libs="${__dir}/libs/*.bash"
for _config_file in ${__libs}; do
    source "${_config_file}"
done

source "${__dir}/theme/colors.bash"

source "${__dir}/environ.bash"
source "${__dir}/aliases.bash"


__plugins="${__dir}/plugins/*.bash"
for _config_file in ${__plugins}; do
    source "${_config_file}"
done


__completion="${__dir}/completion/*.bash"
for _config_file in ${__completion}; do
    source "${_config_file}"
done


_short-dirname () {
  local dir_name=`dirs -0`
  [ ${#dir_name} -gt 8 ] && echo ${dir_name##*/} || echo $dir_name
}

_short-command () {
  local input_command="$@"
  local short=${input_command%% *}
  local icon=""

  case "${short}" in
    "docker") icon="🐋 ";;
    "vim") icon="📗 ";;
    "make") icon="⚒️ ";;
  esac

  echo ${icon}${short}
}

set_xterm_title () {
  local title="$1"
  echo -ne "\033]0;$title\007"
}

reload_history () {
  history -a 
  history -c
  history -r
}

precmd () {
  set_xterm_title "$(_short-dirname)"
  reload_history
}

preexec () {
  set_xterm_title "$(_short-command $1)"
}

preexec_install
