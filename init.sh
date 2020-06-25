readonly COLOR_ERROR="\033[0;31m"
readonly COLOR_WARNING="\033[0;33m"
readonly COLOR_SUCCESS="\033[0;32m"
readonly NO_COLOR="\033[0m"

success () {

    local message="${1:-Sucess}"

    echo -e "${COLOR_SUCCESS}$message${NO_COLOR}"

}

warning () {

    local message="${1:-Warning}"

    echo -e "${COLOR_WARNING}$message${NO_COLOR}"

}

error () {

    local message="${1:-Error}"

    echo -e "${COLOR_ERROR}$message${NO_COLOR}"
}

git-profile () {

    warning "Cloning gist..."

    local clone=$(git clone -q https://gist.github.com/6e11b99a007e660656e147e88fde4bc0 /tmp/gists)

    if [[ $clone -eq 0 ]]; then

        success "Gist successfully cloned"

        if [[ -e "~/.gitconfig" ]]; then

            warning "File .git-config already exists"

            warning "Replacing content..."

            mv /tmp/gists/git-config ~/.gitconfig

            success

        else

            warning "File .gitconfig doesn't exists"

            warning "Creating file..."

            cat /tmp/gists/git-config > ~/.gitconfig

            success

        fi

    else

        error

    fi

    warning "Removing /tmp/gists"

    rm -rf "/tmp/gists"

    if [[ ! -d "/tmp/gists" ]]; then

        success "Files successfully removed"

    else

        error

    fi

}

copy-profile () {

    local hasPreferences=$(cat ~/.zshrc | grep -c "source ~/dotfiles/zshrc")

    if [[ $hasPreferences -eq 0 ]]; then

        warning "Appending preferences..."

        echo "source ~/dotfiles/zshrc" >> ~/.zshrc

        hasPreferences=$(cat ~/.zshrc | grep -c "source ~/dotfiles/zshrc")

        [[ $hasPreferences -eq 1 ]] && success "Preferences successfully applied"

    else

        warning "Profile already applied"

    fi

}

main () {

    echo "Starting..."

    git-profile

    copy-profile

    echo "Done!"

}

main "$@"