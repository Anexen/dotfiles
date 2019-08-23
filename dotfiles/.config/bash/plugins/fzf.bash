#!/usr/bin/env bash

. /usr/share/fzf/key-bindings.bash

# remap fzf CTRL-T to CTRL-F
bind -x '"\C-t": ""'
bind -x '"\C-f": "fzf-file-widget"'

# fzf preview
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
