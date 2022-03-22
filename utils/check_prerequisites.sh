check-prerequisites () {

    info-me 'Looking for necessary tools...'

    local REQUIRED_TOOLS=(
        curl
        zsh
        vim
        git
    )

    local missing_tools=()

    for TOOL in "${REQUIRED_TOOLS[@]}"; do

        which $TOOL 2>&1 > /dev/null

        if [[ $? -ne 0 ]]; then

            warning-me "Missing tool: $TOOL"

            missing_tools+=("$TOOL")

        else

            info-me "$TOOL is installed"

        fi

    done

    if [[ ${#missing_tools[@]} -ne 0 ]]; then

        error-me 'The configuration can not proceed'

        error-me 'Please, install the necessary tools and try again'

        info-me "Run 'sudo apt-get install -y ${missing_tools[*]}'"

        exit 1

    else

        success-me 'All set to proceed with the  configuration'

    fi

    echo

}
