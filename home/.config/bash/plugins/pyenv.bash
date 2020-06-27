#!/usr/bin/env bash

export PYENV_ROOT="${HOME}/.pyenv"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

path_add "${PYENV_ROOT}/bin"

if _command_exists pyenv; then
  eval "$(pyenv init - bash)"
fi

# pyenv-virtualenv plugin is very slow
# disable it in favor of ondir

# Load pyenv virtualenv if the virtualenv plugin is installed.
# if _command_exists pyenv virtualenv-init; then
#   eval "$(pyenv virtualenv-init - bash)"
# fi
