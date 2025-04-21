#!/usr/bin/env bash

# https://wiki.archlinux.org/index.php/XDG_Base_Directory
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [[ "${TERM}" = "alacritty" && -z "${TMUX}" ]]; then
    exec tmux
fi

if [ -f "${HOME}/.secrets.bash" ]; then
    source "${HOME}/.secrets.bash"
fi

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
export dotfiles="${HOME}/.dotfiles"

# Automatically trim long paths in the prompt
export PROMPT_DIRTRIM=5
# ignoreboth = ignorespace + ignoredups
export HISTCONTROL=ignoreboth:erasedups
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=20000
# export HISTFILESIZE=20000
export HISTIGNORE="&:ls:reboot:pwd:exit:clear:bg:fg*:nvim:history"

# source other files

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${__dir}/libs/helpers.bash"
# source "${__dir}/libs/preexec.bash"
# source "${__dir}/theme/colors.bash"

source "${__dir}/environ.bash"
source "${__dir}/aliases.bash"
source "${__dir}/readline.bash"

path_add "${HOME}/bin"
path_add "${HOME}/.local/bin"
path_add "${HOME}/.cargo/bin"
# path_add "${HOME}/.dotnet/tools"

if [[ -n "${GOPATH}" ]]; then
    path_add "${GOPATH}/bin"
fi

if [[ -n "${NPM_CONFIG_PREFIX}" ]]; then
    path_add "${NPM_CONFIG_PREFIX}/bin"
fi

# source "${__dir}/plugins/battery.bash"
source "${__dir}/plugins/fonts.bash"
source "${__dir}/plugins/fzf.bash"
# source "${__dir}/plugins/pyenv.bash"
source "${__dir}/plugins/ssh.bash"
source "${__dir}/plugins/starship.bash"

source "${__dir}/completion/third-party.bash"

if _command_exists devbox; then
    eval "$(devbox global shellenv)"
    source <(devbox completion bash)
fi

if _command_exists direnv; then
    export DIRENV_LOG_FORMAT=''  # mute direnv
    eval "$(direnv hook bash)"
else
    echo "direnv is not installed"
fi

if  _command_exists fzf; then
    source "${__dir}/libs/forgit/forgit.plugin.sh"
    source "${__dir}/libs/fzf-marks/fzf-marks.plugin.bash"
else
    echo "FZF is not installed"
fi

