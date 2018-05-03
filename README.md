# Dotfiles

Arquivos para configurar e personalizar a interface do terminal assim como mais algumas outras funcionalidades.

## Como fica o terminal

O log se divide em quatro partes:

1. Data e hora atual
2. Nome de usuário logado
3. Diretório atual de trabalho
4. Nome da branch caso haja uma pasta `.git/`

```bash
[dd/mm/yyyy | hh:MM:ss] nomeDoUsuário:diretórioAtual (nome da branch) $
```

## Instalação

1. Clone o repositório em sua `home/`:
    ```bash
    git clone https://github.com/LucasVmigotto/dotfiles.git $HOME/dotfiles
    ```
2. Entre no diretório do projeto:
    ```bash
    cd dotfiles
    ```
3. Execute o `dotfiles`:
    ```bash
    ./dotfile
    ```