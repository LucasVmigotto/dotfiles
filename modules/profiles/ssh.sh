ssh-config () {

    local URL_SSH_PROFILE='https://gist.github.com/LucasVmigotto/fd6c7eae2e2476390b44d4e83fc50e64'

    info-me 'Cloning ssh config gist'

    local clone=$(git clone -q $URL_SSH_PROFILE /tmp/gists/ssh-config)

    if [[ $clone -eq 0 ]]; then

        success-me 'SSH config gist successfully cloned'

        [[ ! -d "$HOME/.ssh" ]] &&
            warning-me '.ssh folder does not exists, creating...' &&
            mkdir $HOME/.ssh &&
            success-me '.ssh folder successfully created'

        if [[ -e "$HOME/.ssh/config" ]]; then

            warning-me 'SSH config file already exists, updating...'

            local updated=$(cat /tmp/gists/ssh-config/ssh-config > $HOME/.ssh/config)

            [[ $updated -eq 0 ]] &&
                success-me 'SSH config file successfully updated' ||
                error-me 'SSH config file could not be updated'

        else

            info-me 'SSH config file does not exists, creating...'

            local created=$(cat /tmp/gists/ssh-config/ssh-config > $HOME/.ssh/config)

            [[ $created -eq 0 ]] &&
                success-me 'SSH config file successfully created' ||
                error-me 'SSH config file could not be created'

        fi

    else

        error-me 'SSH config file gist could not be cloned'

        return 1

    fi

    info-me 'Removing SSH config gist'

    rm -rf /tmp/gists/ssh-config

    [[ ! -d '/tmp/gists/ssh-config' ]] &&
        success-me 'Gist successfully removed' ||
        error-me 'Gist could not be removed'

    echo

}
