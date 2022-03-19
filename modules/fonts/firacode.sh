furacode-mono () {

    local has_firacode_mono=$(fc-list | grep -c 'Fura')

    [[ $has_firacode_mono -gt 0 ]] &&
        warning-me 'FuraCode fonts already installed, skipping...' &&
        return 0

    info-me 'FuraCode font is not installed'

    local URL_FURACODE_MONO='https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraMono/Regular/complete/Fura%20Mono%20Regular%20Nerd%20Font%20Complete%20Mono.otf'

    info-me 'Downloading FuraCode fonts'

    curl -sSLo /tmp/furacode.otf $URL_FURACODE_MONO

    [[ -e '/tmp/furacode.otf' ]] &&
        success-me 'FuraCode successfully downloaded' ||
        (error-me 'FuraCode fonts could not be downloaded' && return 1)

    info-me 'Coping FuraCode font to system fonts folder'

    cp /tmp/furacode.otf $HOME/.local/share/fonts

    local copied=$(ls -a $HOME/.local/share/fonts | grep -c 'fura')

    [[ $copied -ne 0 ]] &&
        success-me 'Font successfully copied' ||
        error-me 'Font could no be copied'

    info-me 'Refreshing font cache'

    fc-cache -f $HOME/.local/share/fonts

    info-me 'Removing FuraCode font file from /tmp'

    rm -f /tmp/furacode.otf

    [[ ! -d '/tmp/furacode.otf' ]] &&
        success-me 'Font file successfully removed' ||
        error-me 'Font file could not be removed'

    echo

}

firacode-regular () {

    local has_firacode_mono=$(fc-list | grep -c 'FiraCode')

    [[ $has_firacode_mono -gt 0 ]] &&
        warning-me 'FiraCode fonts already installed, skipping...' &&
        return 0

    info-me 'FiraCode font is not installed'

    local URL_FIRACODE_REGULAR='https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip'

    info-me 'Downloading FiraCode fonts'

    curl -sSLo /tmp/firacode.zip $URL_FIRACODE_REGULAR

    [[ -e '/tmp/firacode.zip' ]] &&
        success-me 'FiraCode successfully downloaded' ||
        (error-me 'FiraCode fonts could not be downloaded' && return 1)

    info-me 'Extracting font file'

    unzip -q /tmp/firacode.zip -d /tmp/firacode

    [[ -d '/tmp/firacode' ]] &&
        success-me 'FiraCode successfully extracted' ||
        (error-me 'FiraCode fonts could not be extracted' && return 1)

    info-me 'Coping font to system fonts folder'

    cp /tmp/firacode/**/*.ttf $HOME/.local/share/fonts

    local copied=$(ls -a $HOME/.local/share/fonts | grep -c 'FiraCode-')

    [[ $copied -ne 0 ]] &&
        success-me 'Fonts successfully copied' ||
        error-me 'Fonts could no be copied'

    info-me 'Refreshing font cache'

    fc-cache -f $HOME/.local/share/fonts

    info-me 'Removing FiraCode .zip and folder from /tmp'

    rm -f /tmp/firacode.zip

    [[ ! -e '/tmp/firacode.zip' ]] &&
        success-me 'Font zip successfully removed' ||
        error-me 'Font zip could not be removed'

    rm -rf /tmp/firacode

    [[ ! -d '/tmp/firacode' ]] &&
        success-me 'Font folder successfully removed' ||
        error-me 'Font folder could not be removed'

    echo

}

firacode () {

    [[ ! -d "$HOME/.local/share/fonts" ]] &&
        warning-me 'Font types folder does not exists, creating...' &&
        mkdir -p $HOME/.local/share/fonts &&
        success-me 'Font types folder successfully created'

    firacode-regular

    furacode-mono

}
