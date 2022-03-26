preferences-config () {

    local URL_PREFERENCES_PROFILE='https://gist.github.com/LucasVmigotto/828f21060561ac67fa6d526f02c027f4'

    info-me 'Cloning preferences config gist'

    local clone=$(git clone -q $URL_PREFERENCES_PROFILE /tmp/gists/preferences-config)

    [[ $clone -eq 0 ]] &&
        success-me 'Preferences config gist successfully cloned' ||
        (error-me 'Preferences config gist could not be cloned' && return 1)

    local PREFERENCES_FILES=(
        $(ls /tmp/gists/preferences-config)
    )

    for FILE in "${PREFERENCES_FILES[@]}"; do

        local DCONF_KEY=$(head -1 /tmp/gists/preferences-config/$FILE | sed 's/^\[\(.*\)]$/\/\1\//')

        info-me "Loading $DCONF_KEY from $FILE"

        local applied=$(dconf load / < /tmp/gists/preferences-config/$FILE )

        [[ $applied -eq 0 ]] &&
            success-me 'Preference successfully loaded' ||
            (
                error-me 'Preference could not be loaded' &&
                warning-me "Conf $DCONF_KEY not setted"
            )

    done

    info-me 'Removing preferences config gist'

    rm -rf /tmp/gists/preferences-config

    [[ ! -d '/tmp/gists/preferences-config' ]] &&
        success-me 'Preferences config gist successfully removed' ||
        (error-me 'Preferences config gist could not be removed' && return 1)

    echo

}
