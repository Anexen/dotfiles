#!/usr/bin/env bash

export PYENV_ROOT="${HOME}/.pyenv"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PYTHON_CONFIGURE_OPTS="--enable-shared"

path_add "${PYENV_ROOT}/bin"

source "${PYENV_ROOT}/completions/pyenv.bash"

workon () {
    local _name="${1:-$(cat .python-version)}"
    local _venv="${PYENV_ROOT}/versions/${_name}"
    source "${_venv}/bin/activate"

    # mimics virtualenvwrapper postactivate
    # https://virtualenvwrapper.readthedocs.io/en/latest/scripts.html#postactivate
    if [[ -f "${_venv}/bin/postactivate" ]]; then
        source "${_venv}/bin/postactivate"
    fi

    # TODO: postdeactivate hook
    # https://bitbucket.org/virtualenvwrapper/virtualenvwrapper/src/f481be386e527c53bb2cc81ed965b66a93d4e792/virtualenvwrapper.sh?at=master#lines-789
}

# get rid of shims
# if _command_exists pyenv; then
#   eval "$(pyenv init - bash)"
# fi

# pyenv-virtualenv plugin is very slow
# disable it in favor of ondir

# Load pyenv virtualenv if the virtualenv plugin is installed.
# if _command_exists pyenv virtualenv-init; then
#   eval "$(pyenv virtualenv-init - bash)"
# fi
