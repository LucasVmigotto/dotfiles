# dotfiles

## Como usar

1. Clone o repositório

    ```bash
        git clone https://github.com/LucasVmigotto/dotfiles $HOME/dotfiles
    ```

2. Instale [Zsh](http://www.zsh.org/)

    ```bash
        sudo apt-get install zsh
    ```

3. Defina o Zsh como o seu Shell padrão

    ```bash
        chsh -s $(which zsh)
    ```

    > Para ativar as mudanças feitas, faça Log off e Log in novamente

4. Instale [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)

    ```bash
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ```

5. Adicione o repositório de dois plugins

    ```bash
        git clone https://github.com/zsh-users/zsh-autosuggestions.git \
            $ZSH_CUSTOM/plugins/zsh-autosuggestions
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
            $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    ```

6. Execute o script para aplicar as preferências e personalizações

    ```bash
        sh ~/dotfiles/init.sh
    ```
