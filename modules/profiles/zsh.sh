omzsh-install () {

    info-me 'Checking if oh-my-zsh is installed'

    [[ -d "$HOME/.oh-my-zsh" ]] &&
        warning-me 'oh-my-zsh already installed, skipping...' &&
        return 0

    warning-me 'oh-my-zsh is not installed'

    local URL_OH_MY_ZSH='https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh'

    info-me 'Downloading oh-my-zsh'

    curl -sSo /tmp/omzsh.sh $URL_OH_MY_ZSH

    [[ -e '/tmp/omzsh.sh' ]] &&
        success-me 'oh-my-zsh successfully installed' ||
        (error-me 'oh-my-zsh could not be installed' && return 1)

    info-me 'Installing oh-my-zsh'

    sh /tmp/omzsh.sh&

    wait $!

    [[ -d "$HOME/.oh-my-zsh" ]] &&
        success-me 'oh-my-zsh successfully installed' ||
        (error-me 'oh-my-zsh could not be installed' && return 1)

    info-me 'Removing oh-my-zsh install script from /tmp'

    rm -f /tmp/omzsh.sh

    [[ ! -e '/tmp/omzsh.sh' ]] &&
        success-me 'oh-my-zsh install script successfully removed' ||
        error-me 'oh-my-zsh install script could not be removed'

    echo

}

omzhs-plugins () {

    info-me "Installing ZSH Plugins"

    local ZSH_PLUGIN_FOLDER="$HOME/.oh-my-zsh/custom/plugins"

    local ZSH_PLUGIN_NAMES=(
        zsh-autosuggestions
        zsh-syntax-highlighting
    )

    local ZSH_PLUGIN_REPOSITORIES=(
        https://github.com/zsh-users/zsh-autosuggestions.git
        https://github.com/zsh-users/zsh-syntax-highlighting.git
    )

    for INDEX in "${!ZSH_PLUGIN_NAMES[@]}"; do

        if [[ ! -d "$ZSH_PLUGIN_FOLDER/${ZSH_PLUGIN_NAMES[$INDEX]}" ]]; then

            warning-me "Installing ${ZSH_PLUGIN_NAMES[$INDEX]} zsh plugin"

            git clone -q "${ZSH_PLUGIN_REPOSITORIES[$INDEX]}" \
                "$ZSH_PLUGIN_FOLDER/${ZSH_PLUGIN_NAMES[$INDEX]}"

            [[ -d "$ZSH_PLUGIN_FOLDER/${ZSH_PLUGIN_NAMES[$INDEX]}" ]] &&
                success-me "Plugin ${ZSH_PLUGIN_NAMES[$INDEX]} successfully installed" ||
                error-me "Plugin ${ZSH_PLUGIN_NAMES[$INDEX]} could not be installed"

        else

            info-me "ZSH Plugin ${ZSH_PLUGIN_NAMES[$INDEX]} already installed, skipping..."

        fi

    done

    echo

}

zsh-profile () {

    local URL_ZSHRC_PROFILE='https://gist.github.com/LucasVmigotto/51176199db9c35e7a17668a7f9071d74'

    info-me 'Cloning ZSH config gist'

    local clone=$(git clone -q $URL_ZSHRC_PROFILE /tmp/gists/zsh-config)

    if [[ $clone -eq 0 ]]; then

        success-me 'ZSH config gist successfully cloned'

        if [[ -e "$HOME/custom.zshrc" ]]; then

            warning-me 'ZSH config file already exists, updating...'

            local updated=$(cat /tmp/gists/zsh-config/custom.zshrc > $HOME/custom.zshrc)

            [[ $updated -eq 0 ]] &&
                success-me 'ZSH config file successfully updated' ||
                error-me 'ZSH config file could not be updated'

        else

            info-me 'custom.zshrc file does not exists, creating...'

            local created=$(cat /tmp/gists/zsh-config/custom.zshrc > $HOME/custom.zshrc)

            [[ $created -eq 0 ]] &&
                success-me 'ZSH config file successfully created' ||
                error-me 'ZSH config file could not be created'

            local has_custom_file_appended=$(cat $HOME/.zshrc | grep -c 'custom.zshrc')

            [[ $has_custom_file_appended -eq 0 ]] &&
                warning-me 'ZSH custom file not appended to .zshrc' &&
                echo "source $HOME/custom.zshrc" >> $HOME/.zshrc &&
                success-me 'Custom ZSH file successfully appended to .zshrc' ||
                warning-me 'ZSH custom file already appended to .zshrc'

        fi

    else

        error-me 'ZSH config file gist could not be cloned'

        return 1

    fi

    info-me 'Removing ZSH config gist'

    rm -rf /tmp/gists/zsh-config

    [[ ! -d '/tmp/gists/zsh-config' ]] &&
        success-me 'Gist successfully removed' ||
        error-me 'Gist could not be removed'

    echo

}

zsh-config () {

    omzsh-install

    omzhs-plugins

    zsh-profile

}
