#!/usr/bin/env bash

## Readline bindings ##

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[1;5D": backward-word'
bind '"\e[1;5C": forward-word'

# Perform file completion in a case insensitive fashion
bind "set completion-ignore-case on"
# Treat hyphens and underscores as equivalent
bind "set completion-map-case on"
# Display matches for ambiguous patterns at first tab press
# bind "set show-all-if-ambiguous on"
# Immediately add a trailing slash when autocompleting symlinks to directories
bind "set mark-symlinked-directories on"
# color files by types
bind "set colored-stats on"
# append char to indicate type
bind "set visible-stats on"
# color the common prefix
bind "set colored-completion-prefix on"
# color the common prefix in menu-complete
bind "set menu-complete-display-prefix on"


# append to the history file, don't overwrite it (from multiple shells)
shopt -s histappend
# save multiline commands as single history records
shopt -s cmdhist
# minor errors in the spelling of a directory name in a cd command will be corrected
shopt -s cdspell
# cd into a dir by just typing the dir name
shopt -s autocd
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# This allows you to bookmark your favorite places across the file system
# Define a variable containing a path and you will be able to cd into it regardless of the directory you're in
shopt -s cdable_vars

export projects="${HOME}/projects"
export dotfiles="${projects}/dotfiles"
export aprenita="${projects}/aprenita/aprenita"
export infrastructure="${projects}/aprenita/aprenita-infrastructure"

# Automatically trim long paths in the prompt
PROMPT_DIRTRIM=5

# ignoreboth = ignorespace + ignoredups 
HISTCONTROL=ignoreboth:erasedups
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=5000
HISTFILESIZE=5000


__generate_ps1() {
  local environ=""

  if [[ -n "${VIRTUAL_ENV}" ]]; then
    environ="("$(basename "${VIRTUAL_ENV}")") "
  fi

  local time="${PIGreen}[\t]${PColorOff}"
  local shell="${PIBlue} \u@\h:${PColorOff}"
  local wd="${PGreen}\w${PColorOff}"
  local scm="${PYellow}$(__git_ps1)${PColorOff}"
  local greet="\n${PIGreen}└─ \$${PColorOff} "

  PS1="${environ}${time}${shell}${wd}${scm}${greet}"
}

PROMPT_COMMAND=__generate_ps1

# source other files

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

# configure preexec

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
