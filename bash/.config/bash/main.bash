#!/usr/bin/env bash

if [ -d "${HOME}/bin" ]; then
    PATH="${HOME}/bin:${PATH}"
fi

if [ -d "${HOME}/.local/bin" ]; then
    PATH="${HOME}/.local/bin:${PATH}"
fi

if [ -f "${HOME}/.secrets.bash" ]; then
    source "${HOME}/.secrets.bash"
fi

## Readline bindings ##

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
# bind '"\e[1;5D": backward-word'
# bind '"\e[1;5C": forward-word'

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
# disable deep
bind "set bell-style none"

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

# cd bookmarks
export projects="${HOME}/projects"
export dotfiles="${HOME}/.dotfiles"
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
  local last_exit_code=$?
  local environ=""
  local greet_color

  if [[ ${last_exit_code} = 0 ]]; then
    greet_color="${PIGreen}"
  else
    greet_color="${PIRed}"
  fi

  if [[ -n "${VIRTUAL_ENV}" ]]; then
    environ="("$(basename "${VIRTUAL_ENV}")") "
  fi

  local time="${PIGreen}[\t]${PColorOff}"
  local shell="${PIBlue} \u@\h:${PColorOff}"
  local wd="${PGreen}\w${PColorOff}"
  local scm="${PYellow}$(__git_ps1)${PColorOff}"
  local greet="\n${greet_color}└─ \$${PColorOff} "

  PS1="${environ}${time}${shell}${wd}${scm}${greet}"
}

PROMPT_COMMAND=__generate_ps1

# source other files

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${__dir}/libs/helpers.bash"
source "${__dir}/libs/preexec.bash"

source "${__dir}/theme/colors.bash"
source "${__dir}/environ.bash"
source "${__dir}/aliases.bash"

source "${__dir}/plugins/battery.bash"
source "${__dir}/plugins/fzf.bash"
source "${__dir}/plugins/forgit.bash"
source "${__dir}/plugins/pyenv.bash"
source "${__dir}/plugins/ssh.bash"

source "${__dir}/completion/third-party.bash"

# configure preexec

_short_dirname () {
  local dir_name=`dirs -0`
  [ ${#dir_name} -gt 8 ] && echo ${dir_name##*/} || echo $dir_name
}


_short_command () {
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


reload_history () {
  history -a
  history -c
  history -r
}


function preexec_xterm_title_install () {
    # These functions are defined here because they only make sense with the
    # preexec_install below.
    function precmd () {
        local screen_info=" "
        if [[ -n $SCREEN_HOST ]]; then
            screen_info=" (${USER}@${SCREEN_HOST}) "
        fi
        preexec_xterm_title "$(_short_dirname)${screen_info}$PROMPTCHAR"
        if [[ "${TERM}" == screen ]]; then
            preexec_screen_title "`preexec_screen_user_at_host`${PROMPTCHAR}"
        fi
        reload_history
    }

    function preexec () {
        local screen_info=""
        if [[ -n $SCREEN_HOST ]]; then
            screen_info=" (${USER}@${SCREEN_HOST}) "
        fi
        preexec_xterm_title "$(_short_command $1)${screen_info}"
        if [[ "${TERM}" == screen ]]; then
            local cutit="$1"
            local cmdtitle=`echo "$cutit" | cut -d " " -f 1`
            if [[ "$cmdtitle" == "exec" ]]
            then
                local cmdtitle=`echo "$cutit" | cut -d " " -f 2`
            fi
            if [[ "$cmdtitle" == "screen" ]]
            then
                # Since stacked screens are quite common, it would be nice to
                # just display them as '$$'.
                local cmdtitle="${PROMPTCHAR}"
            else
                local cmdtitle=":$cmdtitle"
            fi
            preexec_screen_title "`preexec_screen_user_at_host`${PROMPTCHAR}$cmdtitle"
        fi
    }

    preexec_install
}

preexec_xterm_title_install

