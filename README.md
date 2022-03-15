# dotfiles

Personal dotfiles to customize my [Linux](https://www.linux.org/) environment

## Prerequisites Configuration

> You have to be already installed [ZSH](https://www.zsh.org/), [cURL](https://curl.se/), [Vim](https://www.vim.org/) and [Git](https://git-scm.com/).

* Define, if you already didn't do it, the [ZSH](https://www.zsh.org/) as your terminal interpreter

    ```bash
    chsh -s $(which zsh)
    ```

    > You need to logout and login on your user to apply the change

## Usage

1. Clone the repository

    * HTTPS

        ```bash
        git clone https://github.com/LucasVmigotto/dotfiles $HOME/dotfiles
        ```

    * SSH

        ```bash
        git clone git@github.com:LucasVmigotto/dotfiles.git $HOME/dotfiles
        ```

2. Run the main script

    ```bash
    bash $HOME/dotfiles/dotfiles.sh
    ```
