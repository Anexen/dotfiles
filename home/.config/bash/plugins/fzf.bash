#!/usr/bin/env bash

if [[ -d /usr/share/fzf ]]; then
    source /usr/share/fzf/completion.bash
    source /usr/share/fzf/key-bindings.bash

    # remap fzf CTRL-T to CTRL-F
    bind -x '"\C-t": ""'
    bind -x '"\C-f": "fzf-file-widget"'
else
    echo "FZF completion file not found"
fi

# fzf preview
export FZF_DEFAULT_COMMAND='fd --type f --hidden --no-ignore-vcs --follow | sort'
export FZF_PREVIEW_COMMAND='(bat --color=always --style=plain --theme TwoDark {} || tree -C {}) 2> /dev/null'
export FZF_DEFAULT_OPTS='--layout=reverse --preview-window right,50%,border-sharp --bind "ctrl-r:toggle-sort,alt-j:preview-down,alt-k:preview-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up,alt-bs:execute-multi(rm {})+reload($FZF_DEFAULT_COMMAND)"'
export FZF_CTRL_T_OPTS="--preview '"$FZF_PREVIEW_COMMAND" | head -200'"

# fzf rm
frm() {
    local files
    IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))

    [[ -n "$files" ]] && rm "${files[@]}"
}

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

# Same as above, but allows multi selection:
function drm() {
  docker ps -a | sed 1d | fzf -q "$1" --no-sort -m --tac | awk '{ print $1 }' | xargs -r docker rm -f
}

# Select a docker image or images to remove
function drmi() {
  docker images | sed 1d | fzf -q "$1" --no-sort -m --tac | awk '{ print $3 }' | xargs -r docker rmi -f
}
