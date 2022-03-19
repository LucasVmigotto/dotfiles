editorconfig-config () {

    local URL_EDITORCONFIG_PROFILE='https://gist.github.com/LucasVmigotto/701de1ff6eb7f02d7179438760bf6734'

    info-me 'Cloning .editorconfig config gist'

    local clone=$(git clone -q $URL_EDITORCONFIG_PROFILE /tmp/gists/editorconfig)

    if [[ $clone -eq 0 ]]; then

        success-me '.editorconfig gist successfully cloned'

        if [[ -e "$HOME/.editorconfig" ]]; then

            warning-me '.editorconfig file already exists, updating...'

            local updated=$(cat /tmp/gists/editorconfig/.editorconfig > $HOME/.editorconfig)

            [[ $updated -eq 0 ]] &&
                success-me '.editorconfig file successfully updated' ||
                error-me '.editorconfig file could not be updated'

        else

            info-me '.editorconfig file does not exists, creating...'

            local created=$(cat /tmp/gists/editorconfig/.editorconfig > $HOME/.editorconfig)

            [[ $created -eq 0 ]] &&
                success-me '.editorconfig file successfully created' ||
                error-me '.editorconfig file could not be created'

        fi

    else

        error-me '.editorconfig file gist could not be cloned'

        return 1

    fi

    info-me 'Removing .editorconfig gist'

    rm -rf /tmp/gists/editorconfig

    [[ ! -d '/tmp/gists/editorconfig' ]] &&
        success-me 'Gist successfully removed' ||
        error-me 'Gist could not be removed'

    echo

}
