git-config () {

    local URL_GIT_PROFILE='https://gist.github.com/LucasVmigotto/6e11b99a007e660656e147e88fde4bc0'

    info-me 'Cloning git config gist'

    local clone=$(git clone -q $URL_GIT_PROFILE /tmp/gists/git-config)

    if [[ $clone -eq 0 ]]; then

        success-me 'Git config gist successfully cloned'

        if [[ -e "$HOME/.gitconfig" ]]; then

            warning-me 'Git config file already exists, updating...'

            local updated=$(cat /tmp/gists/git-config/.gitconfig > $HOME/.gitconfig)

            [[ $updated -eq 0 ]] &&
                success-me 'Git config file successfully updated' ||
                error-me 'Git config file could not be updated'


        else

            info-me '.gitconfig file does not exists, creating...'

            local created=$(cat /tmp/gists/git-config/.gitconfig > $HOME/.gitconfig)

            [[ $created -eq 0 ]] &&
                success-me 'Git config file successfully created' ||
                error-me 'Git config file could not be created'

        fi

    else

        error-me 'Git config file gist could not be cloned'

        return 1

    fi

    info-me 'Removing Git config gist'

    rm -rf /tmp/gists/git-config

    [[ ! -d '/tmp/gists/git-config' ]] &&
        success-me 'Gist successfully removed' ||
        error-me 'Gist could not be removed'

    echo

}
