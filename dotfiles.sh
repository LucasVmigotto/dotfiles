#!/usr/bin/env bash

# Functions
source $HOME/dotfiles/utils/notifyme.sh
source $HOME/dotfiles/utils/check_prerequisites.sh

# Profiles
source $HOME/dotfiles/modules/profiles/git.sh
source $HOME/dotfiles/modules/profiles/editorconfig.sh
source $HOME/dotfiles/modules/profiles/ssh.sh
source $HOME/dotfiles/modules/profiles/terminal.sh
source $HOME/dotfiles/modules/profiles/vim.sh
source $HOME/dotfiles/modules/profiles/zsh.sh

# Fonts
source $HOME/dotfiles/modules/fonts/firacode.sh
source $HOME/dotfiles/modules/fonts/powerline.sh
source $HOME/dotfiles/modules/fonts/roboto.sh

profiles () {

    git-config

    editorconfig-config

    ssh-config

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

    check-prerequisites

    fonts

    profiles

}

main "$@"
