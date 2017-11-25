#!/usr/bin/env bash

shopt -s nullglob

log_info()
{
    echo -e "\e[1;32mINFO: $* \e[0m" >&2
}

log_error()
{
    echo -e "\e[1;31mERROR: $* \e[0m" >&2
}

# Installing software lists from system software mirror source
DEBIAN_TOOLS="curl make gcc g++ build-essential python-dev python-pip vim git-gui ssh chromium synaptic tig \
python3 python3-pip python3-dev inxi tmux msmtp mutt irssi virtualbox unzip npm nodejs fcitx fcitx-rime lynx sysstat \
axel"

CENTOS_TOOLS="ca-certificates.noarch yum-axelget.noarch git-email.noarch git-gui.noarch vim-enhanced.x86_64 chromium.x86_64 \
python34.x86_64 python34-pip.noarch python34-devel.x86_64 tig.x86_64 cmake.x86_64 axel.x86_64 \
python2-pip.noarch python-devel.x86_64 inxi.noarch tmux.x86_64 msmtp.x86_64 mutt.x86_64 irssi.x86_64 unzip.x86_64 \
nodejs.x86_64 lynx.x86_64 centos-release-scl devtoolset-3-toolchain"

usage()
{
	cat >&2 <<-EOF
Usage:
    $0 <-t centos|debian>

Options:
    -t centos|debian:   install useful or necessary softwares to Debian or CentOS 7.

Examples:
    $0 -t centos
    $0 -t debian

EOF
	exit 1
}

check_command()
{
    local comm="$1"

    command -v "$comm" > /dev/null || {
        log_error "please install $comm package mannually."
        return 1
    }
}

have_sudo_right()
{
    sudo -v &> /dev/null || {
        log_error "$USER not in sudo group."
        return 1
    }
}

is_blank()
{
    local type="$1"
    local contents=$(grep -v -e "^#" -e "^$" "${apps_dirs}/${type}-third-apps.txt")

	[[ "$contents" ]] || {
        log_error "${type}-third-apps.txt file has no any contents and please check it."
        return 1
    }
}

debian_install()
{
    local urls="$1"
    local pkg_name

    while read -r line; do
        pkg_name=$(basename "$line")

        log_info "downloading $pkg_name package ..."

        if wget -c "$line" -o /dev/null -P "$TEMP_DIRS"; then
            log_info "installing extra software packages $pkg_name ..."
            sudo dpkg --install "$TEMP_DIRS/$pkg_name" > /dev/null || {
                # apt should try to resolve broken dependencies and no need to apt update again
                sudo apt-get install -f -y > /dev/null || {
                    log_error "auto fix broken dependencies failed in $pkg_name"
                    return 1
                }

                sudo dpkg --install "$TEMP_DIRS/$pkg_name" > /dev/null || {
                    log_error "please resove dependencies manually and then reinstall $pkg_name again."
                    return 1
                }
            }
        else
            log_error "can not download package $pkg_name because of Internet."
            continue
        fi
    done <<< "$urls"

    return 0
}

debian_install_apps()
{
    log_info "update software mirrors and upgrade some softwares ..."
    sudo apt-get update > /dev/null && sudo apt-get upgrade -y > /dev/null

    for tool_name in $DEBIAN_TOOLS; do
        log_info "will install $tool_name software ..."

        sudo apt-get install -y "$tool_name" > /dev/null || {
            # apt should fix broken dependency and try again
            sudo apt-get install -f -y > /dev/null || {
                log_error "apt cannot fix broken dependency in $tool_name, please check it."
                return 1
            }

            sudo apt-get install -y "$tool_name" > /dev/null || {
                log_error "apt-get can not install $tool_name software normally and please check error manually."
                sudo rm -rf /var/lib/apt/lists/*.deb
                return 1
            }
        }
    done

    sudo rm -rf /var/lib/apt/lists/*.deb

    return 0
}

centos_install()
{
    local urls="$1"
    local pkg_name

    while read -r line; do
        pkg_name=$(basename "$line")

        log_info "downloading $pkg_name package ..."

        if wget -c "$line" -o /dev/null -P "$TEMP_DIRS"; then
            pkgs_name=$(basename "$line")
			log_info "installing extra software packages $pkg_name ..."

            sudo rpm --install "$TEMP_DIRS/$pkgs_name" > /dev/null || {
                # CentOS resolves broken dependencies automatically some trouble:
                # sudo yum install -y $(yum deplist $pkgs_name | grep "provider" | awk '{print $2}' | sort -u)
                # A good idea: https://stackoverflow.com/questions/13876875/how-to-make-rpm-auto-install-dependencies
                sudo yum --nogpgcheck localinstall "$TEMP_DIRS/$pkgs_name" -y > /dev/null || {
                    log_error "please resove dependencies manually and then reinstall $pkg_name"
                    return 1
                }
            }
        else
            log_error "can not download package $(basename $line) because of Internet."
            continue
        fi
    done <<< "$urls"

    return 0
}

centos_install_apps()
{
    local repo_files="$1"

    log_info "adding more software repos for CentOS."
    sudo cp -f $repo_files/* /etc/yum.repos.d || return

    log_info "building metadata for all enabled yum repos."
    sudo yum makecache fast > /dev/null || return

    # First install epel-release.noarch to get more package from repo
    log_info "installing epel-release.noarch ..."
    sudo yum install -y epel-release.noarch > /dev/null || return

    log_info "installing Development Tools component, please hold on a moment ..."
    sudo yum groups install "Development Tools" -y > /dev/null || return

    for tool_name in $CENTOS_TOOLS; do
        log_info "will install $tool_name software ..."

        sudo yum install -y "$tool_name" > /dev/null || {
            # Maybe yum cann't auto-resolve broken dependency like Debian apt
            log_error "yum can not install software normally and please check error manually."
            return 1
        }
    done

    return 0
}

clean_tmp()
{
	rm -rf "$TEMP_DIRS"
}

while getopts "t:h" opt; do
    case "$opt" in
        t)  type="$OPTARG"; ;;
        h | ?)    usage;  ;;
    esac
done

[[ $(uname -m) = "x86_64" ]] || {
    log_error "only support x86_64 platform."
    exit 1
}

[[ -z "$type" ]] && {
    log_error "-t option is required."
    exit 1
}

[[ "$type" =~ ^(debian|centos)$ ]] || {
	log_error "only support debian or centos options."
	exit 1
}

if [[ $(id -u) -ne 0 ]]; then
	check_command sudo && have_sudo_right || exit
else
	check_command sudo || exit
fi

check_command wget || exit

if [[ "$type" = "debian" ]]; then
    [[ -f "/usr/lib/apt/methods/https" ]] || {
        log_error "please install apt-transport-https package mannually."
        exit 1
    }
fi

cur_dir=$(cd $(dirname "$0"); pwd)
apps_dirs="$(dirname $cur_dir)/third-party"

trap "clean_tmp" EXIT
TEMP_DIRS=$(mktemp -d)

if [[ "$type" = "debian" ]]; then
	is_blank "$type" || exit
	urls=$(grep -v -e "^#" -e "^$" "${apps_dirs}/$type-third-apps.txt" | awk '{print $NF}')

	debian_install_apps || exit
	debian_install "$urls" || exit
elif [[ "$type" = "centos" ]]; then
	is_blank "$type" || exit
	urls=$(grep -v -e "^#" -e "^$" "${apps_dirs}/$type-third-apps.txt" | awk '{print $NF}')

	centos_install_apps "${apps_dirs}/CentOS" || exit
	centos_install "$urls" || exit
fi

log_info "Congratulations! All softwares have finished installing."
