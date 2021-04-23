#!/usr/bin/env bash

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

# aws cli v2 completion
complete -C aws_completer aws

# complete -W "$(_parse_help ./myscript)" ./myscript

if [[ -f /usr/share/git/completion/git-prompt.sh ]]; then
    source /usr/share/git/completion/git-prompt.sh
    source /usr/share/git/completion/git-completion.bash
fi

if [[ -f /usr/share/bash-complete-alias/complete_alias ]]; then
    source /usr/share/bash-complete-alias/complete_alias

    # make sure aliases.bash was loaded first
    for a in $(alias | cut -d= -f1 | cut -d' ' -f2); do
        complete -F _complete_alias $a;
    done
fi
