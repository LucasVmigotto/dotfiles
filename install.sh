#!/usr/bin/env bash

# set -euo pipefail
#
# [[ "${TRACE:-0}" == 1 ]] && set -x

# shellcheck disable=SC1091
readonly DISTRO=$(. /etc/os-release && echo "$ID_LIKE")
readonly COLOR_ERROR="\033[0;31m"
readonly COLOR_SUCCESS="\033[0;32m"
readonly NO_COLOR="\033[0m"

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

        echo "    |_ Git already installed"

        configure-git

    else

        echo "    |_ Installing Git..."

        egit=$(sudo -E apt-get update && sudo -E apt-get install -qq -y git)

        if [[ $egit ]]; then

            success "    |_ Git successfully installed"

            configure-git

        else

            error "    |_ Error installing Git"

        fi

    fi
}

configure-git() {
	local clone tmpdir copy

	echo "==> Git configuration"

	tmpdir="/tmp/git$(date +"%s")"

    echo "    |_ Getting settings from gist..."

	clone=$(git clone -q https://gist.github.com/6e11b99a007e660656e147e88fde4bc0 "$tmpdir")

	if [[ "$clone" -eq 0 ]]; then

        success "    |_ Settings successfully cloned"

        printf "    |_ Copy settings... "

		copy=$(cp "$tmpdir/git-config" "$HOME/.gitconfig")

		if [[ "$copy" -eq 0 ]]; then

			success

			rm -rf "$tmpdir"

		else

			error

		fi

	else

		error "    |_ Error cloning the settings"

	fi
}

configure-profile() {

	local filebash isconfig fileconfig

	echo "==> Profile"

	filebash="$HOME/.bashrc"

	fileconfig="$HOME/dotfiles/bashrc"

	if [[ -f $filebash ]]; then

		printf "    |_ Inserting profile in .bashrc... "

		isconfig=$(grep -c "$fileconfig" "$filebash")

		if [[ $isconfig -eq 1 ]]; then

			echo -e "\n    ${COLOR_ERROR}|_ Profile already defined.${NO_COLOR}"

		else

			echo ". $fileconfig" >> "$filebash"

			success

		fi

	else

		echo -e "\n    |_ ${COLOR_ERROR}.bashrc file not found${NO_COLOR}"

	fi
}

start() {

    echo "==> Starting..."

}

finish() {

    echo "==> Finished..."

}

main() {
	start

	if [[ "$DISTRO" == "debian" ]]; then

        git-install

        configure-profile

		finish

		exit 0

	else

		echo -e "\n    |_ ${COLOR_ERROR}System not distribution .deb${NO_COLOR}"

		end

		exit 1

	fi
}

main "$@"
