#!/usr/bin/env bash

. /usr/share/fzf/completion.bash
. /usr/share/fzf/key-bindings.bash

# remap fzf CTRL-T to CTRL-F
bind -x '"\C-t": ""'
bind -x '"\C-f": "fzf-file-widget"'

# fzf preview
export FZF_DEFAULT_OPTS='--layout=reverse  --bind "alt-j:preview-down,alt-k:preview-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up"'
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
function fe() {
    local files
    IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))

    [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# git checkout branch
function gcb() {
    local branch
    branch=$(git for-each-ref --format='%(refname:short)' refs/heads | fzf -q "$1")
    [[ -n "$branch" ]] && git checkout $branch
}

# Select a docker container to start and attach to
function dca() {
    local cid
    cid=$(docker ps -a | sed 1d | fzf -1 -q "$1" | awk '{print $1}')

    [[ -n "$cid" ]] && docker start "$cid" && docker attach "$cid"
}

# Select a running docker container to stop
function dcs() {
    local cid
    cid=$(docker ps | sed 1d | fzf -q "$1" | awk '{print $1}')

    [[ -n "$cid" ]] && docker stop "$cid"
}

# Select a docker container to remove
function dcr() {
    local cid
    cid=$(docker ps -a | sed 1d | fzf -q "$1" | awk '{print $1}')

    [[ -n "$cid" ]] && docker rm "$cid"
}
