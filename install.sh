#!/usr/bin/env bash

# set -euo pipefail
#
# [[ "${TRACE:-0}" == 1 ]] && set -x

# shellcheck disable=SC1091
readonly DISTRO=$(. /etc/os-release && echo "$ID_LIKE")
readonly COLOR_ERROR="\033[0;31m"
readonly COLOR_SUCCESS="\033[0;32m"
readonly NO_COLOR="\033[0m"
readonly TAB="    |_"

check-permissions () {
    if [[ "$UID" -ne "$ROOT_UID" ]]; then

    error "=> You must run this command as root"

    exit $ERROR_NOTROOT

fi
}

success() {

    local message="${1:-Sucess}"

    echo -e "${COLOR_SUCCESS}$message${NO_COLOR}"

}

error() {

    local message="${1:-Error}"

    echo -e "${COLOR_ERROR}$message${NO_COLOR}"

}

git-install () {

    local egit

    echo "==> Git"

    if [[ $(git --version) ]]; then

        echo "$TAB Git already installed"

        configure-git

    else

        echo "$TAB Installing Git"

        egit=$(sudo -E apt-get update && sudo -E apt-get install -qq git)

        if [[ $egit ]]; then

            success "$TAB Git successfully installed"

            configure-git

        else

            error "$TAB Error installing Git"

        fi

    fi
}

configure-git() {

    local clone tmpdir copy

	echo "==> Git configuration"

	tmpdir="/tmp/git$(date +"%s")"

    echo "$TAB Getting settings from gist"

	clone=$(git clone -q https://gist.github.com/6e11b99a007e660656e147e88fde4bc0 "$tmpdir")

	if [[ "$clone" -eq 0 ]]; then

        success "$TAB Settings successfully cloned"

        printf "$TAB Copy settings "

		copy=$(cp "$tmpdir/git-config" "$HOME/.gitconfig")

		if [[ "$copy" -eq 0 ]]; then

			success

			rm -rf "$tmpdir"

		else

			error

		fi

	else

		error "$TAB Error cloning the settings"

        0

	fi

    git-lfs
}

git-lfs () {

    echo "==> Git LFS"

    if [[ $(which git-lfs) != "" ]]; then

        echo "$TAB Already installed, skipping..."

        exit 0

    fi

    echo "$TAB Installing git-lfs"

    apt-get install -qq git-lfs

    if [[ $? -eq 0 ]]; then

        success "$TAB git-lfs successfully installed"

    else

        error "$TAB Error installing git-lfs"

        exit 1

    fi

}

configure-profile() {

	local filebash isconfig fileconfig

	echo "==> Profile"

	filebash="$HOME/.bashrc"

	fileconfig="$HOME/dotfiles/bashrc"

	if [[ -f $filebash ]]; then

		printf "$TAB Inserting profile in .bashrc "

		isconfig=$(grep -c "$fileconfig" "$filebash")

		if [[ $isconfig -eq 1 ]]; then

			echo -e "\n    ${COLOR_ERROR}|_ Profile already defined.${NO_COLOR}"

		else

			echo ". $fileconfig" >> "$filebash"

			success

		fi

	else

		echo -e "\n$TAB ${COLOR_ERROR}.bashrc file not found${NO_COLOR}"

	fi
}

vscode () {

    if [[ $(which code) != "" ]]; then

        echo "$TAB Already installed, skipping..."

        exit 0

    fi

    download_vscode

    install-vscode

    vscode-extensions
}

download-vscode () {

    local DIRECTORY="/tmp/code.deb"
    local VSCODE_URL="https://vscode-update.azurewebsites.net/latest/linux-deb-x64/stable"

    echo "$TAB Downloading VSCode"

    echo -e "\n"

    curl -L -o "$DIRECTORY" "$VSCODE_URL"

    echo -e "\n"

    if [[ -f "$DIRECTORY" ]]; then

        success "$TAB VSCode downloaded into $DIRECTORY"

    else

        error "$SUB Error downloading VSCode"

    fi

}

install-vscode () {

    local DIRECTORY="/tmp/code.deb"

    echo "$TAB Installing VSCode"

    dpkg -i -E "$DIRECTORY"

    if [[ $(which code) ]]; then

        success "$TAB VSCode Installed"

        echo "$TAB removing $DIRECTORY"

        rm -rf "$DIRECTORY"

        if [[ -f "$DIRECTORY" ]]; then

            error "$TAB Error removing $DIRECTORY"

        else

            success

        fi

    else

        error "$TAB Error installing VSCode"

    fi

}

vscode-extensions () {

    local GIST_URL="https://gist.github.com/47904ee4f36b70c9d84a30d29d996aed.git"
    local GIST_DIR="/tmp/gist"

    echo "$TAB Getting VSCode extensions ids"

    git clone -q $GIST_URL $GIST_DIR

    if [[ ! -f $GIST_DIR ]]; then

        success "$TAB Extensions successfully listed"

    else

        error "$TAB Error while listing"

        exit 1

    fi

    while read ext; do

        if [[ "$ext" != "" ]]; then

            code --install-extension "$ext"

        else

            exit 0

        fi

    done < /tmp/gist/vscode-extensions

    echo "$TAB Removing temporary file $GIST_DIR"

    rm -rf "/tmp/gist"

    success "$TAB VSCode extensions successfully installed"

}

utilities () {

    echo "==> Utilities"

    local UTILITIES=(
        "vlc"
        "transmission"
        "xclip"
        "openvpn"
        "tree"
    )

    for ext in "${EXTENSIONS[@]}"; do

        print "$TAB $ext: "

        if [[ $(which $ext) != "" ]]; then

            echo "already installed, skipping..."

        else

            echo "Installing $ext"

            apt-get install -qq $ext

            [[ $($ext --version) ]] && success "$TAB $ext successfully installed"

        fi

    done

}

yarn () {

    echo "==> Yarn"

    if [[ $(which yarn) != "" ]]; then

        echo "$TAB Already installed, skipping..."

        exit 0

    fi

    echo "$TAB Adding the Yarn gpg key"

    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -

    echo "$TAB Setting up the stable version"

    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

    echo "$TAB Retrive new list of packages"

    apt-get update

    echo "$TAB Install Yarn"

    apt-get yarn

    if [[ $(yarn --version) ]]; then

        success "$TAB Yarn successfully installed"

    else

        error "$TAB Error during the installation"

    fi

}

asdf () {

    echo "==> asdf"

    if [[ $(which asdf != "") ]]; then

        echo "$TAB Already installed, skipping..."

    fi

    echo "$TAB Cloning the asdf repository"

    git clone https://github.com/asdf-vm/asdf.git ~/.asdf

    if [[ -f "~/.asdf" ]]; then

        echo "$TAB checking out to the last branch"

        cd $HOME/.asdf

        git checkout "$(git describe --abbrev=0 --tags)"

        echo "$TAB configuring asdf into the .bashrc"

        echo -e "\n. $HOME/.asdf/asdf.sh" >>$HOME/.bashrc

        cd $HOME

    else

        error "$TAB Error cloning the repository"

        exit 1

    fi

}

docker () {

    local VERSION="deb [arch=amd64] https://download.docker.com/linux/ubuntu    $(lsb_release -cs)    stable"

    echo "==> Docker"

    if [[ $(which docker != "") ]]; then

        echo "$TAB Already installed, skipping..."

    fi

    echo "$TAB Installing necessary scripts"

    apt-get install -qq \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common

    if [[ $? -eq 0 ]]; then

        success "$TAB Dependencies successfully installed"

    else

        error "$TAB Error during installation"

        exit 0

    fi

    echo "$TAB Adding docker gpg key"

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    echo "$TAB Setting up the stable version"

    add-apt-repository $VERSION

    echo "$TAB Retrive new list of packages"

    apt-get update

    echo "$TAB Install docker"

    apt-get install docker-ce docker-ce-cli containerd.io

    if [[ $(docker --version) ]]; then

        success "$TAB Docker successfully installed"

    else

        error "$TAB Error during the installation"

    fi

    after-doker

}

after-docker () {

    local hGroup=$(groups | grep -c "docker")

    if [[ $hGroup -ne 1 ]]; then

        echo "$TAB Creating docker group"

        groupadd docker

    fi

    [[ $(groups | grep -c "docker") ]] && success "$TAB Group successfully created"

    echo "$TAB Adding the current user to the docker group"

    usermod -aG docker $(logname)

    #local uGroup=$(grep docker /etc/group | grep -c "$(logname)")
    #
    #if [[ $uGroup -eq 1 ]]; then
    #
    #    success "$TAB User successfully added"
    #
    #else
    #
    #    error "$TAB User not added"
    #
    #    exit 0
    #
    #fi

    d-compose

}

d-compose () {

    echo "$TAB Cloning last version of docker compose"

    curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

    if [[ -f "/usr/local/bin/docker-compose" ]]; then

        success "$TAB Successfully cloned the release"

    else

        error "$TAB Error cloning"

        exit

    fi

    echo "$TAB Giving executable permissions"

    chmod +x /usr/local/bin/docker-compose

    echo "$TAB Creating symbolic link to the executable"

    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

    [[ -f /usr/local/bin/docker-compose ]] && success "$TAB Link created"

}

start() {

    echo "=> Starting"

}

finish() {

    echo "=> Finished"

}

main() {

    check-permissions

	start

	if [[ "$DISTRO" == "debian" ]]; then

        git-install

        configure-profile

        vscode

        docker

        asdf

        yarn

        utilities

        echo "==>\e[30;48;5;82m You may have to reboot you PC to apply some changes\e[0m"

        finish

		exit 0

	else

		echo -e "\n$TAB ${COLOR_ERROR}System not distribution .deb${NO_COLOR}"

		end

		exit 1

	fi
}

main "$@"
