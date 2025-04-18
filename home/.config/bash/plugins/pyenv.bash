#!/usr/bin/env bash

export PYENV_ROOT="${HOME}/.pyenv"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PYTHON_CONFIGURE_OPTS="--enable-shared"

path_add "${PYENV_ROOT}/bin"

source "${PYENV_ROOT}/completions/pyenv.bash"

mkvirtualenv () {
    local python_version="${1?python version is required}"
    local venv_name="${2?venv name is required}"
    "${PYENV_ROOT}/versions/${python_version}/bin/python" -m venv "${PYENV_ROOT}/versions/${venv_name}"
}

rmvirtualenv () {
    rm -rf "${PYENV_ROOT}/versions/${1?venv name is required}"
}

lsvirtualenv () {
    ls "${PYENV_ROOT}/versions/"
}

workon () {
    local venv_name="${1:-$(cat .python-version)}"
    local venv_root="${PYENV_ROOT}/versions/${venv_name}"
    source "${venv_root}/bin/activate"

    # mimics virtualenvwrapper postactivate
    # https://virtualenvwrapper.readthedocs.io/en/latest/scripts.html#postactivate
    if [[ -f "${venv_root}/bin/postactivate" ]]; then
        source "${venv_root}/bin/postactivate"
    fi

    # TODO: postdeactivate hook
    # https://github.com/python-virtualenvwrapper/virtualenvwrapper/blob/main/virtualenvwrapper.sh#L695
}

if _command_exists pyenv; then
  eval "$(pyenv init - bash)"
fi

# pyenv-virtualenv plugin is very slow
# disable it in favor of ondir

# Load pyenv virtualenv if the virtualenv plugin is installed.
# if _command_exists pyenv virtualenv-init; then
#   eval "$(pyenv virtualenv-init - bash)"
# fi
