#!/usr/bin/env bash

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

    echo

}

missingSymbols () {

    hasFont=$(fc-list | grep -c PowerlineSymbols.otf)

    [[ $hasFont -eq 1 ]] && warning "Zsh symbols already installed" && return

    warning "Installing PowerlineSymbols..."

    wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf \
        -P /tmp

    [[ -f "/tmp/PowerlineSymbols.otf" ]] && success

    warning "Installing font config..."

    wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf \
        -P /tmp

    [[ -f "/tmp/10-powerline-symbols.conf" ]] && success

    [[ ! -d "~/.local/share/fonts/" ]] &&
        warning "Directory ~/.local/share/fonts/ not found, creating..." &&
        mkdir -p ~/.local/share/fonts/ &&
        success

    warning "Moving PowerlineSymbols.otf to ~/.local/share/fonts/"

    mv /tmp/PowerlineSymbols.otf ~/.local/share/fonts/

    [[ -f "~/.local/share/fonts/PowerlineSymbols.otf" ]] && success

    warning "Refreshing font cache"

    fc-cache -f ~/.local/share/fonts/

    [[ ! -d "~/.config/fontconfig/conf.d/" ]] &&
        warning "Directory ~/.config/fontconfig/conf.d/ not found, creating..." &&
        mkdir -p ~/.config/fontconfig/conf.d/ &&
        success

    warning "Moving font config file to ~/.config/fontconfig/conf.d/"

    mv /tmp/10-powerline-symbols.conf ~/.config/fontconfig/conf.d/

    echo

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

    missingSymbols

    echo

}

roboto-fonts () {

    local hasAnyRobotoFonts=$(fc-list | grep -c Roboto)

    if [[ $hasAnyRobotoFonts -eq 0 ]]; then

        local FILE_ROBOTO_REGULAR="/tmp/roboto-regular.zip"
        local DIR_ROBOTO_REGULAR="/tmp/roboto-regular"
        local URL_ROBOTO_REGULAR="https://fonts.google.com/download?family=Roboto"
        local FILE_ROBOTO_MONO="/tmp/roboto-mono.zip"
        local DIR_ROBOTO_MONO="/tmp/roboto-mono"
        local URL_ROBOTO_MONO="https://fonts.google.com/download?family=Roboto%20Mono"

        warning "Dowloading Roboto fonts..."

        curl $URL_ROBOTO_REGULAR -sSo $FILE_ROBOTO_REGULAR

        [[ -f "$FILE_ROBOTO_REGULAR" ]] &&
            success "Roboto regular successfully installed in $FILE_ROBOTO_REGULAR"

        curl $URL_ROBOTO_MONO -sSo $FILE_ROBOTO_MONO

        [[ -f "$FILE_ROBOTO_MONO" ]] &&
            success "Roboto mono successfully installed in $FILE_ROBOTO_MONO"

        warning "Unziping downloaded fonts..."

        unzip "$FILE_ROBOTO_REGULAR" -d "$DIR_ROBOTO_REGULAR"

        unzip "$FILE_ROBOTO_REGULAR" -d "$DIR_ROBOTO_REGULAR"

        [[ -d "$DIR_ROBOTO_REGULAR" ]] &&
            [[ -d "$DIR_ROBOTO_MONO" ]] &&
            success "Files successfully extracted"

        warning "Moving fonts files to ~/.local/share/fonts/"

        mv "$DIR_ROBOTO_REGULAR/*.ttf" "~/.local/share/fonts/"

        mv "$DIR_ROBOTO_MONO/*.ttf" "~/.local/share/fonts/"

        local robotoRegularMoved=$(ls -la ~/.local/share/fonts | grep -c Roboto-)
        local robotoMonoMoved=$(ls -la ~/.local/share/fonts | grep -c RobotoMono)

        [[ $robotoRegularMoved -ne 0 ]] &&
            [[ $robotoMonoMoved -ne 0 ]] &&
            success "Roboto fonts successfully moved"

        warning "Refreshing fonts..."

        fc-cache -f ~/.local/share/fonts/

        local robotoRegularApplied=$(fc-list | grep -c Roboto-)
        local robotoMonoApplied=$(fc-list | grep -c RobotoMono)

        [[ $robotoRegularApplied -ne 0 ]] &&
            [[ $robotoMonoApplied -ne 0 ]] &&
            success "Roboto fonts successfully applied"

    else

        warning "Roboto fonts already installed, skipping..."

    fi

    echo
}

main () {

    echo "Starting..."

    git-profile

    copy-profile

    roboto-fonts

    echo "Done!"

}

main "$@"
