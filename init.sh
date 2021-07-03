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

    warning "Writing Git profile file"

    if [[ ! -f ~/.gitconfig ]]; then

        local URL_GIT_PROFILE="https://gist.githubusercontent.com/LucasVmigotto/6e11b99a007e660656e147e88fde4bc0/raw/c02f384a831e5d708f0cbe5f4fdfb580f0410a1c/git-config"

        curl -sS $URL_GIT_PROFILE > ~/.gitconfig

        [[ -f ~/.gitconfig ]] &&
            success "Profile successfully copied"

    else

        warning "Git config profile already exists, skipping..."

    fi

    echo

}

missing-symbols () {

    local URL_POWER_SYMBOLS="https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf"
    local URL_POWER_SYMBOLS_CONF="https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf"

    hasFont=$(fc-list | grep -c PowerlineSymbols.otf)

    [[ $hasFont -eq 1 ]] && warning "Zsh symbols already installed" && return

    warning "Installing PowerlineSymbols..."

    curl $URL_POWER_SYMBOLS -sSo /tmp/PowerlineSymbols.otf

    [[ -f "/tmp/PowerlineSymbols.otf" ]] && success

    warning "Installing font config..."

    curl $URL_POWER_SYMBOLS_CONF -sSo /tmp/10-powerline-symbols.conf

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

    missing-symbols

    echo

}

roboto-fonts () {

    local hasAnyRobotoFonts=$(fc-list | grep -c Roboto)

    if [[ $hasAnyRobotoFonts -eq 0 ]]; then

        local URL_ROBOTO_REGULAR="https://fonts.google.com/download?family=Roboto"
        local URL_ROBOTO_MONO="https://fonts.google.com/download?family=Roboto%20Mono"

        warning "Dowloading Roboto fonts..."

        curl $URL_ROBOTO_REGULAR -sSo /tmp/roboto_regular.zip

        [[ -f "/tmp/roboto_regular.zip" ]] &&
            success "Roboto regular successfully installed in /tmp/roboto_regular.zip"

        curl $URL_ROBOTO_MONO -sSo /tmp/roboto_mono.zip

        [[ -f "/tmp/roboto_mono.zip" ]] &&
            success "Roboto mono successfully installed in /tmp/roboto_mono.zip"

        warning "Unziping downloaded fonts..."

        unzip -q /tmp/roboto_regular.zip -d /tmp/roboto_regular

        unzip -q /tmp/roboto_mono.zip -d /tmp/roboto_mono

        [[ -d "/tmp/roboto_regular" ]] &&
            [[ -d "/tmp/roboto_mono" ]] &&
            success "Files successfully extracted"

        warning "Moving fonts files to ~/.local/share/fonts/"

        mkdir -p ~/.local/share/fonts/

        mv /tmp/roboto_regular/*.ttf ~/.local/share/fonts/

        mv /tmp/roboto_mono/**/*.ttf ~/.local/share/fonts/
        mv /tmp/roboto_mono/*.ttf ~/.local/share/fonts/

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

        warning "Removing /tmp/roboto_regular /tmp/roboto_mono and .zip files"

        rm -rf "/tmp/roboto_regular" \
            "/tmp/roboto_regular.zip" \
            "/tmp/roboto_mono" \
            "/tmp/roboto_mono.zip"

        local countRobotoFonts=$(ls -a /tmp | grep -c roboto)

        if [[ $countRobotoFonts -eq 0 ]]; then

            success "Files successfully removed"

        else

            error

        fi

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
