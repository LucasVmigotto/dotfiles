roboto-regular () {

    local has_roboto_regular=$(fc-list | grep -c 'Roboto')

    [[ $has_roboto_regular -gt 0 ]] &&
        warning-me 'Roboto Regular fonts already installed, skipping...' &&
        return 0

    info-me 'Roboto Regular fonts is not installed'

    local URL_ROBOTO_REGULAR='https://fonts.google.com/download?family=Roboto'

    info-me 'Downloading Reboto Regular fonts'

    curl -sSo /tmp/roboto_regular.zip $URL_ROBOTO_REGULAR

    [[ -e '/tmp/roboto_regular.zip' ]] &&
        success-me 'Roboto Regular successfully downloaded' ||
        error-me 'Roboto Regular fonts could not be downloaded' && exit 1

    info-me 'Extracting font file'

    unzip -q /tmp/roboto_regular.zip -d /tmp/roboto_regular

    [[ -d '/tmp/roboto_regular' ]] &&
        success-me 'Roboto Regular successfully extracted' ||
        error-me 'Roboto Regular fonts could not be extracted' && exit 1

    info-me 'Coping font to system fonts folder'

    cp /tmp/roboto_regular/*.ttf $HOME/.local/share/fonts

    local copied=$(ls -a $HOME/.local/share/fonts | grep -c 'Roboto-')

    [[ $copied -ne 0 ]] &&
        success-me 'Fonts successfully copied' ||
        error-me 'Fonts could no be copied'

    info-me 'Refreshing font cache'

    fc-cache -f $HOME/.local/share/fonts

    info-me 'Removing Roboto Regular .zip and folder from /tmp'

    rm /tmp/roboto_regular.zip

    [[ ! -e '/tmp/roboto_regular.zip' ]] &&
        success-me 'Font zip successfully removed' ||
        error-me 'Font zip could not be removed'

    rm -rf /tmp/roboto_regular

    [[ ! -d '/tmp/roboto_regular' ]] &&
        success-me 'Font folder successfully removed' ||
        error-me 'Font folder could not be removed'

    echo

}

roboto-mono () {

    local has_roboto_mono=$(fc-list | grep -c 'RobotoMono')

    [[ $has_roboto_mono -gt 0 ]] &&
        warning-me 'RobotoMono fonts already installed, skipping...' &&
        return 0

    info-me 'RobotoMono fonts is not installed'

    local URL_ROBOTO_MONO='https://fonts.google.com/download?family=Roboto%20Mono'

    info-me 'Downloading Reboto Mono fonts'

    curl -sSo /tmp/roboto_mono.zip $URL_ROBOTO_MONO

    [[ -e '/tmp/roboto_mono.zip' ]] &&
        success-me 'RobotoMono successfully downloaded' ||
        error-me 'RobotoMono fonts could not be downloaded' && exit 1

    info-me 'Extracting font file'

    unzip -q /tmp/roboto_mono.zip -d /tmp/roboto_mono

    [[ -d '/tmp/roboto_mono' ]] &&
        success-me 'RobotoMono successfully extracted' ||
        error-me 'RobotoMono fonts could not be extracted' && exit 1

    info-me 'Coping font to system fonts folder'

    cp /tmp/roboto_mono/**/*.ttf $HOME/.local/share/fonts

    local copied=$(ls -a $HOME/.local/share/fonts | grep -c 'RobotoMono-')

    [[ $copied -ne 0 ]] &&
        success-me 'Fonts successfully copied' ||
        error-me 'Fonts could no be copied'

    info-me 'Refreshing font cache'

    fc-cache -f $HOME/.local/share/fonts

    info-me 'Removing RobotoMono .zip and folder from /tmp'

    rm /tmp/roboto_mono.zip

    [[ ! -e '/tmp/roboto_mono.zip' ]] &&
        success-me 'Font zip successfully removed' ||
        error-me 'Font zip could not be removed'

    rm -rf /tmp/roboto_mono

    [[ ! -d '/tmp/roboto_mono' ]] &&
        success-me 'Font folder successfully removed' ||
        error-me 'Font folder could not be removed'

    echo

}

roboto () {

    [[ ! -d "$HOME/.local/share/fonts" ]] &&
        warning-me 'Font types folder does not exists, creating...' &&
        mkdir -p $HOME/.local/share/fonts &&
        success-me 'Font types folder successfully created'

    roboto-regular

    roboto-mono

}
