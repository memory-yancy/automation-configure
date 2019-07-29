# Related functions or ideas see below followings:
#
## https://github.com/jessfraz/dotfiles/blob/master/.functions

source <(pip completion --bash 2>/dev/null || true)
source <(npm completion 2>/dev/null || true)
[[ ! -f "/usr/share/autojump/autojump.bash" ]] || source /usr/share/autojump/autojump.bash

LOG_INFO()
{
    echo -e "\e[0;32m[$(date '+%T.%3N') INFO]: $* \e[0m"
}

LOG_ERROR()
{
    echo -e "\e[0;31m[$(date '+%T.%3N') ERROR]: $* \e[0m"
}

man()
{
    env LESS_TERMCAP_mb="$(printf '\e[1;31m')" \
        LESS_TERMCAP_md="$(printf '\e[1;31m')" \
        LESS_TERMCAP_me="$(printf '\e[0m')" \
        LESS_TERMCAP_se="$(printf '\e[0m')" \
        LESS_TERMCAP_so="$(printf '\e[1;44;33m')" \
        LESS_TERMCAP_ue="$(printf '\e[0m')" \
        LESS_TERMCAP_us="$(printf '\e[1;32m')" \
        man "$@"
}

less()
{
    env LESS_TERMCAP_mb="$(printf '\e[1;31m')" \
        LESS_TERMCAP_md="$(printf '\e[1;31m')" \
        LESS_TERMCAP_me="$(printf '\e[0m')" \
        LESS_TERMCAP_se="$(printf '\e[0m')" \
        LESS_TERMCAP_so="$(printf '\e[1;44;33m')" \
        LESS_TERMCAP_ue="$(printf '\e[0m')" \
        LESS_TERMCAP_us="$(printf '\e[1;32m')" \
        less "$@"
}

source_condaenv()
{
    local env_name="${1:?conda env name is missing}"
    local conda_dir="${2:-${HOME}/conda2}"
    local conda_env

    [[ "$env_name" = "--help" || "$env_name" = "-h" ]] && {
        LOG_INFO "Usage: ${FUNCNAME[0]} <env_name> [conda_prefix_dir]\n"
        return 1
    }

    [[ -x "${conda_dir}/bin/conda-env" ]] || {
        LOG_ERROR "can not find conda-env command in $conda_dir ..."
        return 1
    }

    LOG_INFO "activate [ $env_name ] conda env ..."
    conda_env=$("${conda_dir}/bin/conda-env" list --json)
    conda_env=$(python -c "import os,json,sys; print('\n'.join([os.path.basename(i) for i in json.loads(sys.stdin.read())['envs']]))" <<<"$conda_env")
    echo "$conda_env" | grep -w -q "$env_name" || {
        LOG_ERROR "can not find [ $env_name ] conda environment, do nothing and skip it ..."
        return 1
    }
    source "${conda_dir}/bin/activate" "$env_name"
}

deactivate_condaenv()
{
    [[ -z "$CONDA_PREFIX" ]] || {
        # https://github.com/conda/conda/blob/4.4.x/conda/base/constants.py
        [[ "$CONDA_DEFAULT_ENV" =~ ^(root|base)$ ]] || {
            source $(dirname $(dirname "$CONDA_PREFIX"))/bin/deactivate
            return "$?"
        }
        source "${CONDA_PREFIX}/bin/deactivate"
        return "$?"
    }
}
