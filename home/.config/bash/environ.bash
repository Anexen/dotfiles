#!/bin/bash

export EDITOR=nvim
export VISUAL=nvim
export MANPAGER='nvim +Man!'

export TERM="alacritty"

# export SWT_GTK3=0
# export GDK_SCALE=1

export DOCKER_BUILDKIT=1

export GIT_PS1_SHOWCOLORHINTS=true
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUPSTREAM=auto

export BAT_THEME=TwoDark

export NVIM_LOG_FILE="${XDG_DATA_HOME}/nvim/log"

# export AWS_VAULT_SECRET_SERVICE_COLLECTION_NAME="login"
export AWS_VAULT_PROMPT=zenity
export AWS_SESSION_TOKEN_TTL=16h
# export AWS_CHAINED_SESSION_TOKEN_TTL=16h
# export AWS_FEDERATION_TOKEN_TTL=8h
# export AWS_ASSUME_ROLE_TTL=1h
export AWS_DEFAULT_PROFILE=bastion

export GOPATH="${HOME}/.go"
export NPM_CONFIG_PREFIX="${HOME}/.npm"

export RUSTC_WRAPPER=/usr/bin/sccache

export DO_NOT_TRACK=1  # disable devbox telemetry
export NIX_REMOTE=daemon
# export NIX_PATH=nixpkgs=channel:nixpkgs
