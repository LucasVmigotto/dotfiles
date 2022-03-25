terminal-config () {

    local URL_TERMINAL_PROFILE='https://gist.github.com/LucasVmigotto/828f21060561ac67fa6d526f02c027f4'

    info-me 'Cloning terminal config gist'

    local clone=$(git clone -q $URL_TERMINAL_PROFILE /tmp/gists/terminal-config)

    if [[ $clone -eq 0 ]]; then

        success-me 'Terminal config gist successfully cloned'

        local profile_applied=$(cat /tmp/gists/terminal-config/terminal_profile.dconf | dconf load /org/gnome/terminal/legacy/profiles:/)

        [[ $profile_applied -eq 0 ]] &&
            success-me 'Terminal profile successfully applied' ||
            error-me 'Terminal profile could not be applied'

    else

        error-me 'Terminal config file gist could not be cloned'

        return 1

    fi

    info-me 'Removing terminal config gist'

    rm -rf /tmp/gists/terminal-config

    [[ ! -d '/tmp/gists/terminal-config' ]] &&
        success-me 'Gist successfully removed' ||
        error-me 'Gist could not be removed'

    echo

}
