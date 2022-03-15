#!/usr/bin/env bash

# Functions
source ./utils/notifyme.sh

# Profiles
source ./modules/profiles/git.sh
source ./modules/profiles/ssh.sh
source ./modules/profiles/terminal.sh
source ./modules/profiles/vim.sh
source ./modules/profiles/zsh.sh

# Fonts
source ./modules/fonts/firacode.sh
source ./modules/fonts/powerline.sh
source ./modules/fonts/roboto.sh

profiles () {

    git-config

    ssg-config

    terminal-config

    vim-config

    zsh-config

}

fonts () {

    powerline

    firacode

    roboto

}

main () {

    profiles

}

main "$@"
