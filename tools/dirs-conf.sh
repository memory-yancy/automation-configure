#!/usr/bin/env bash

config_dirs()
{
    [[ -d "${HOME}/repo" && -d "${HOME}/github" && -d "${HOME}/test" ]] || {
        mkdir -p "${HOME}/repo" "${HOME}/github" "${HOME}/test" || return
    }

    local downloads
    downloads="${HOME}/Downloads"

    [[ -d "${downloads}/apps-source" ]] || {
        mkdir -p "${downloads}/apps-source" || return
    }

    local pictures
    pictures="${HOME}/Pictures"

    [[ -d "${pictures}/screenshots" ]] || {
        mkdir -p "${pictures}/screenshots" || return
    }

    echo "INFO: created ${HOME}/repo ${HOME}/github ${HOME}/test ${downloads}/apps-source ${pictures}/screenshots" >&2
}

[[ "$HOME" ]] || {
    echo "ERROR: \$HOME is NULL!" >&2
    exit 1
}

config_dirs || {
    echo "ERROR: config necessary directories failed." >&2
    exit 1
}
