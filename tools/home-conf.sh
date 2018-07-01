#!/usr/bin/env bash

shopt -s dotglob

log_info()
{
    echo -e "\e[1;32mINFO: $* \e[0m" >&2
}

log_error()
{
    echo -e "\e[1;31mERROR: $* \e[0m" >&2
}

usage()
{
    cat >&2 <<-EOF
Usage:
    $0

EOF
    exit 1
}

check_command()
{
    local cmd="$1"

    command -v "$cmd" > /dev/null || {
        log_error "please install $cmd package and try it again."
        return 1
    }
}

bashrc_conf()
{
    cat >> "${HOME}/.bashrc" <<-EOF
# User alias setting
[[ -s ~/.bash_aliases ]] && source ~/.bash_aliases

# PS1 and PS2 setting
export PS1="\[\e[31;1m\][\u@\[\e[31;1m\]\h \W]$\[\e[0m\] "
export PS2="... "

export PATH="$HOME/.cargo/bin:\$PATH"
export HISTCONTROL="ignoredups:erasedups"

# Proxy/VPN setting in command line mode.
# export http_proxy="http://127.0.0.1:8118"
# export https_proxy="https://127.0.0.1:8118"

EOF
}

user_conf()
{
    local name="$1"
    local conf_files="$2"
    local extra_conf="$3"

    case "$name" in
        debian)
            cp -urf $conf_files/* "$HOME"
            cp -uf $extra_conf/Debian/* "$HOME"
        ;;
        centos)
            cp -ruf $conf_files/* "$HOME"
            cp -uf $extra_conf/CentOS/* "$HOME"
        ;;
    esac

    return 0
}

check_os()
{
    local dist_name

    if [[ -x /usr/bin/lsb_release ]]; then
        dist_name=$(lsb_release -si)
    elif [[ -z "$dist_name" && -r /etc/lsb-release ]]; then
        dist_name=$(. /etc/lsb-release && echo "$DISTRIB_ID")
    elif [[ -z "$dist_name" ]] && [[ -r /etc/debian_version ]]; then
        dist_name="debian"
    elif [[ -z "$dist_name" ]] && [[ -r /etc/fedora-release ]]; then
        dist_name="fedora"
    elif [[ -z "$dist_name" ]] && [[ -r /etc/os-release ]]; then
        dist_name=$(. /etc/os-release && echo "$ID")
    elif [[ -z "$dist_name" ]] && [[ -r /etc/centos-release ]]; then
        dist_name=$(cat /etc/*-release | head -n1 | cut -d " " -f1)
    elif [[ -z "$dist_name" ]] && [[ -r /etc/redhat-release ]]; then
        dist_name=$(cat /etc/*-release | head -n1 | cut -d " " -f1)
    else
        dist_name=$(echo "$dist_name" | cut -d " " -f1)
    fi

    dist_name=$(echo "$dist_name" | tr "[:upper:]" "[:lower:]")

    [[ "$dist_name" = "debian" || "$dist_name" = "centos" ]] || return 1

    echo "$dist_name"
}

check_os > /dev/null || {
    log_error "only support CentOS or Debian."
    exit 1
}

source "$(dirname $(readlink -e -v $BASH_SOURCE))/dirs-conf.sh"
log_info "created required directories and files ..."

cur_dir=$(cd $(dirname "$0"); pwd)
conf_files="$(dirname $cur_dir)/dot-files"
extra_conf="$(dirname $cur_dir)/other-config"

# It has same .bashrc file whichever OS
log_info "updating bashrc file."
bashrc_conf

user_conf "$(check_os)" "$conf_files" "$extra_conf" || exit

log_info "developing environments have finished setting up."
