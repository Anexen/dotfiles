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
PROMPT_DIRTRIM=5

# ignoreboth = ignorespace + ignoredups
HISTCONTROL=ignoreboth:erasedups
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=20000
HISTFILESIZE=20000

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
path_add "${HOME}/.local/pydev-bin"
path_add "${HOME}/.cargo/bin"

# source "${__dir}/plugins/battery.bash"
source "${__dir}/plugins/fzf.bash"
source "${__dir}/plugins/pyenv.bash"
source "${__dir}/plugins/ssh.bash"
source "${__dir}/plugins/sharship.bash"

source "${__dir}/completion/third-party.bash"

# build ondir: cd libs/ondir && sudo make install
if _command_exists ondir; then
    source "${__dir}/libs/ondir/scripts.sh"
else
    echo "Ondir is not installed"
fi

if  _command_exists fzf; then
    source "${__dir}/libs/forgit/forgit.plugin.sh"
    source "${__dir}/libs/fzf-marks/fzf-marks.plugin.bash"
else
    echo "FZF is not installed"
fi

