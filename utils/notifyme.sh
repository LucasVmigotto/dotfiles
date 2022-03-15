readonly COLOR_INFO="\033[0;34m"
readonly COLOR_INFO_BOLD="\033[1;49;34m"
readonly COLOR_ERROR="\033[0;31m"
readonly COLOR_ERROR_BOLD="\033[1;49;31m"
readonly COLOR_WARNING="\033[0;33m"
readonly COLOR_WARNING_BOLD="\033[0;33m"
readonly COLOR_SUCCESS="\033[0;32m"
readonly COLOR_SUCCESS_BOLD="\033[1;49;32m"
readonly NO_COLOR="\033[0m"

success-me () {

    local message="${1:-Sucess}"

    echo -e "${COLOR_SUCCESS_BOLD}Success: ${COLOR_SUCCESS}$message${NO_COLOR}"

}

info-me () {

    local message="${1:-Info}"

    echo -e "${COLOR_INFO_BOLD}Info: ${COLOR_INFO}$message${NO_COLOR}"

}

warning-me () {

    local message="${1:-Warning}"

    echo -e "${COLOR_WARNING_BOLD}Warning: ${COLOR_WARNING}$message${NO_COLOR}"

}

error-me () {

    local message="${1:-Error}"

    echo -e "${COLOR_ERROR_BOLD}Error: ${COLOR_ERROR}$message${NO_COLOR}"

}
