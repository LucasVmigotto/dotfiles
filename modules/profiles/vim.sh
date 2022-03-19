vim-plug-install () {

    local URL_VIM_PLUG='https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

    info-me 'Checking if vim-plug is installed'

    [[ -f "$HOME/.vim/autoload/plug.vim" ]] &&
        warning-me 'vim-plug already installed' &&
        return  0

    warning-me 'vim-plug is not installed, installing...'

    curl -sSfLo $HOME/.vim/autoload/plug.vim --create-dirs \
        $URL_VIM_PLUG

    [[ -e "$HOME/.vim/autoload/plug.vim" ]] &&
        success-me 'vim-plug successfully installed' ||
        error-me 'vim-plug could not be installed'

    echo

}

vim-profile () {

    local URL_VIM_PROFILE='https://gist.github.com/LucasVmigotto/c116cb2e3dc579739145bb4279605701'

    info-me 'Cloning Vim config gist'

    local clone=$(git clone -q $URL_VIM_PROFILE /tmp/gists/vim-config)

    if [[ $clone -eq 0 ]]; then

        success-me 'Vim config gist successfully cloned'

        if [[ -e "$HOME/.vimrc" ]]; then

            warning-me 'Vim config file already exists, updating...'

            local updated=$(cat /tmp/gists/vim-config/.vimrc > $HOME/.vimrc)

            [[ $updated -eq 0 ]] &&
                success-me 'Vim config file successfully updated' ||
                error-me 'Vim config file could not be updated'

        else

            info-me '.vimrc file does not exists, creating...'

            local created=$(cat /tmp/gists/vim-config/.vimrc > $HOME/.vimrc)

            [[ $created -eq 0 ]] &&
                success-me 'Vim config file successfully created' ||
                error-me 'Vim config file could not be created'

        fi

    else

        error-me 'Vim config file gist could not be cloned'

        return 1

    fi

    info-me 'Removing Vim config gist'

    rm -rf /tmp/gists/vim-config

    [[ ! -d '/tmp/gists/vim-config' ]] &&
        success-me 'Gist successfully removed' ||
        error-me 'Gist could not be removed'

    echo

}

vim-config () {

    vim-plug-install

    vim-profile

}
