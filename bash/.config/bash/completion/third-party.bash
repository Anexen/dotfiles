#!/usr/bin/env bash

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

source /usr/share/git/completion/git-prompt.sh
source /usr/share/git/completion/git-completion.bash

