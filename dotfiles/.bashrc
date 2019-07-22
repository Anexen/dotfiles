#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

. ~/.secrets.bash
. ~/.environ.bash
. ~/.aliases.bash
. ~/.colors.bash
. ~/.git-prompt.sh

. /usr/share/fzf/key-bindings.bash
. /usr/share/fzf/completion.bash

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

# ignoreboth = ignorespace + ignoredups 
HISTCONTROL=ignoreboth:erasedups
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=2000
HISTFILESIZE=2000

# save history after every command
PROMPT_COMMAND="${PROMPT_COMMAND}; history -a"

PS1="\[${IGreen}\]"#"\! \[${Cyan}\][\t]\[${IBlue}\] \u@\h:\[${Green}\]\w\[${Yellow}\]\$(__git_ps1)\[${IGreen}\]\n└─ \$\[${Color_Off}\] "

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# start the ssh-agent automatically and make sure that only one process runs at a time,
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent > ~/.ssh-agent-thing
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval "$(<~/.ssh-agent-thing)" > /dev/null
fi

# init pyenv
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

