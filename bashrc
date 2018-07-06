#!/usr/bin/env bash
case "$TERM" in
    xterm) color_prompt=yes;;
    xterm-color) color_prompt=yes;;
    xterm-256color) color_prompt=yes;;
    screen) color_prompt=yes;;
    screen-256color) color_prompt=yes;;
esac

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

git_status() {
    # insertion - see the number of additions
    # deletion  - see the number of deletions
    # changed   - see the number of changed files
    if [[ -e "$PWD/.git" ]] && [[ -d "$PWD/.git" ]];then
        git diff --shortstat | grep "$1" | awk '{print $1}'
    fi
}

black="\[\033[0;30m\]"
blackBold="\[\033[1;30m\]"
blackUnderl="\[\033[4;30m\]"
red="\[\033[0;31m\]"
redBold="\[\033[1;31m\]"
redUnderl="\[\033[4;31m\]"
green="\[\033[0;32m\]"
greenBold="\[\033[1;32m\]"
greenUnderl="\[\033[4;32m\]"
yellow="\[\033[0;33m\]"
yellowLight="\[\033[1;33m\]"
yellowUnderl="\[\033[4;33m\]"
blue="\[\033[0;34m\]"
blueBold="\[\033[1;34m\]"
blueUnderl="\[\033[4;34m\]"
purple="\[\033[0;35m\]"
purpleBold="\[\033[1;35m\]"
purpleUnderl="\[\033[4;35m\]"
cyan="\[\033[0;36m\]"
cyanBold="\[\033[1;36m\]"
cyanUnderl="\[\033[4;36m\]"
white="\[\033[0;37m\]"
whiteBold="\[\033[1;37m\]"
whiteUnderl="\[\033[4;37m\]"

if [[ "$color_prompt" = yes ]];then
    #export PS1="$whiteBold\$(date +'%Y-%m-%d | %H:%M:%S')\n${debian_chroot:+($debian_chroot)}$cyanBold\u$whiteBold@$redBold\h$yellowLight:\W$greenBold\$(parse_git_branch)$whiteBold \$$white "
    export PS1="$whiteBold\$(date +'|%Y-%m-%d | %H:%M:%S|')$purpleBold in $yellowLight\w\n${debian_chroot:+($debian_chroot)}$cyanBold\u$whiteBold@$redBold\h$whiteBold:$greenBold\$(parse_git_branch)$whiteBold \$$white "
else
    export PS1="$whiteBold[\$(data +'%Y/%m/%d | %H:%M:%S')] ${debian_chroot:+($debian_chroot)}\u@\h:\w \$ "
fi

alias open='xdg-open'
