powerline-font () {

    local has_powerline_font=$(fc-list | grep -c PowerlineSymbols.otf)

    [[ $has_powerline_font -eq 1 ]] &&
        warning-me 'PowerlineSymbols font installed, skipping...' &&
        return 0

    local URL_POWER_SYMBOLS_FONT='https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf'

    curl -sSLo /tmp/PowerlineSymbols.otf \
        $URL_POWER_SYMBOLS_FONT

    [[ -e '/tmp/PowerlineSymbols.otf' ]] &&
        success-me 'PowerlineSymbols fonts file successfully downloaded' ||
        error-me 'PowerlineSymbols fonts file could not be installed' && return 1

    info-me 'Coping PowerlineSymbols font file to system fonts folder'

    cp /tmp/PowerlineSymbols.otf $HOME/.local/share/fonts

    [[ -e "$HOME/.local/share/fonts/PowerlineSymbols.otf" ]] &&
        success-me 'PowerlineSymbols successfully copied' ||
        error 'PowerlineSymbols could not be copied'

    info-me 'Refreshing font cache'

    fc-cache -f $HOME/.local/share/fonts

    info 'Removing PowerlineSymbols font file from /tmp'

    rm /tmp/PowerlineSymbols.otf

    [[ ! -e '/tmp/PowerlineSymbols.otf' ]] &&
        success-me 'Font file successfully removed' ||
        error-me 'Font file could not be removed'

    echo


}

powerline-conf () {

    local URL_POWER_SYMBOLS_CONF='https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf'

    if [[ ! -e "$HOME/.config/fontconfig/conf.d/10-powerline-symbols.conf" ]]; then

        curl -sSL $URL_POWER_SYMBOLS_CONF > /tmp/10-powerline-symbols.conf

        [[ -e '/tmp/10-powerline-symbols.conf' ]] &&
            success-me 'PowerlineSymbols conf file successfully downloaded' ||
            error-me 'PowerlineSymbols conf file could not be downloaded' && return 1

        info-me 'Coping PowerlineSymbols conf file to system font conf file'

        cp /tmp/10-powerline-symbols.conf $HOME/.config/fontconfig/conf.d

        [[ -e "$HOME/.config/fontconfig/conf.d/10-powerline-symbols.conf" ]] &&
            success-me 'PowerlineSymbols conf file successfully copied' ||
            error-me 'PowerlineSymbols conf file could not be copied'

        info-me 'Removing PowerlineSymbols conf file from /tmp'

        rm /tmp/10-powerline-symbols.conf

        [[ ! -e '/tmp/10-powerline-symbols.conf' ]] &&
            success-me 'Conf file successfully removed' ||
            error-me 'Conf file could not be removed'

    else

        warning-me 'PowerlineSymbols conf file already exists, skipping...'

    fi

    echo

}

powerline () {

    [[ ! -d "$HOME/.local/share/fonts" ]] &&
        warning-me 'Font types folder does not exists, creating...' &&
        mkdir -p $HOME/.local/share/fonts &&
        success-me 'Font types folder successfully created'

    [[ ! -d "$HOME/.config/fontconfig/conf.d/" ]] &&
        warning-me 'Font config folder does not exists, creating...' &&
        mkdir -p $HOME/.config/fontconfig/conf.d &&
        success-me 'Font config folder successfully created'


    powerline-font

    powerline-conf

}
