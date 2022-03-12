#!/usr/bin/env bash

git-profile () {

    warning "Cloning git config gist..."

    local clone=$(git clone -q https://gist.github.com/6e11b99a007e660656e147e88fde4bc0 /tmp/gists/git-config)

    if [[ $clone -eq 0 ]]; then

        success "Gist successfully cloned"

        if [[ -e "~/.gitconfig" ]]; then

            warning "File .git-config already exists"

            warning "Replacing content..."

            mv /tmp/gists/git-config ~/.gitconfig

            success

        else

            warning "File .gitconfig doesn't exists"

            warning "Creating file..."

            cat /tmp/gists/git-config > ~/.gitconfig

            success

        fi

    else

        error

    fi

    warning "Removing /tmp/gists/git-config"

    rm -rf "/tmp/gists/git-config"

    if [[ ! -d "/tmp/gists/git-config" ]]; then

        success "Files successfully removed"

    else

        error

    fi

    echo

}



copy-profile () {

    local hasPreferences=$(cat ~/.zshrc | grep -c "source ~/dotfiles/zshrc")

    if [[ $hasPreferences -eq 0 ]]; then

        warning "Appending preferences..."

        echo "source ~/dotfiles/zshrc" >> ~/.zshrc

        hasPreferences=$(cat ~/.zshrc | grep -c "source ~/dotfiles/zshrc")

        [[ $hasPreferences -eq 1 ]] && success "Preferences successfully applied"

    else

        warning "Profile already applied"

    fi

    missing-symbols

    echo

}



terminal-profile () {

    warning "Cloning terminal profile gist..."

    local clone=$(git clone -q https://gist.github.com/828f21060561ac67fa6d526f02c027f4.git /tmp/gists/terminal_profile)

    if [[ $clone -eq 0 ]]; then

        success "Gist successfully cloned"

        warning "Copying terminal profile"

        cat /tmp/gists/terminal_profile/terminal_profile.dconf | dconf load /org/gnome/terminal/legacy/profiles:/

        success

    else

        error

    fi

    warning "Removing /tmp/gists/terminal_profile"

    rm -rf "/tmp/gists/terminal_profile"

    if [[ ! -d "/tmp/gists/terminal_profile" ]]; then

        success "Files successfully removed"

    else

        error

    fi

    echo

}

ssh-config () {

    warning "Cloning SSH Config gist..."

    local clone=$(git clone -q https://gist.github.com/fd6c7eae2e2476390b44d4e83fc50e64.git /tmp/gists/ssh-config)

    if [[ $clone -eq 0 ]]; then

        success "Gist successfully cloned"

        warning "Copying terminal profile"

        cat /tmp/gists/ssh-config/config >> $HOME/.ssh/config

        success

    else

        error

    fi

    warning "Removing /tmp/gists/ssh-config"

    rm -rf "/tmp/gists/ssh-config"

    if [[ ! -d "/tmp/gists/ssh-config" ]]; then

        success "Files successfully removed"

    else

        error

    fi

    echo

}

main () {

    echo "Starting..."

    git-profile

    copy-profile

    roboto-fonts

    terminal-profile

    ssh-config

    echo "Done!"

}

main "$@"
