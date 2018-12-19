#!/usr/bin/env bash

# Make sure this script is sourced only once
if ! readonly __SHCOMMONS_LOG_SH_SOURCED= &> /dev/null; then
    return
fi

# Colorize

readonly __NORMAL="$(tput sgr0)"
readonly __BOLD="$(tput bold)"
readonly __BLACK="$(tput setaf 0)"
readonly __DARK_GREY="$(tput bold; tput setaf 0)"
readonly __RED="$(tput setaf 1)"
readonly __LIGHT_RED="$(tput bold; tput setaf 1)"
readonly __GREEN="$(tput setaf 2)"
readonly __LIGHT_GREEN="$(tput bold ; tput setaf 2)"
readonly __BROWN="$(tput setaf 3)"
readonly __YELLOW="$(tput bold; tput setaf 3)"
readonly __BLUE="$(tput setaf 4)"
readonly __LIGHT_BLUE="$(tput bold ; tput setaf 4)"
readonly __MAGENTA="$(tput setaf 5)"     # or Purple
readonly __PINK="$(tput bold; tput setaf 5)"
readonly __CYAN="$(tput setaf 6)"
readonly __LIGHT_CYAN="$(tput bold ; tput setaf 6)"
readonly __LIGHT_GREY="$(tput setaf 7)"
readonly __WHITE="$(tput bold; tput setaf 7)"

psuccessl()
{
    printf "${__GREEN}%s${__NORMAL}\n" "${*}" >&1
}

perrorl()
{
    printf "${__RED}%s${__NORMAL}\n" "${*}" >&2
}

pwarningl()
{
    printf "${__YELLOW}%s${__NORMAL}\n" "${*}" >&2
}

pinfol()
{
    printf "%s\n" "${*}" >&1
}

pusage()
{
    printf "USAGE: %s\n" "${*}" >&2
}

# Display message and pause
pause()
{
    echo "${*}"
    read -s -n1 -p "Press any key to continue.."
}

peval()
{
    local rs rv
    rs=$(eval "${1}" 2>&1); rv="${?}"
    if [ "$rv" != 0 ]; then
        perrorl "${@:2:${#}}" "${1}:" "[$rv]:" "$rs"
        return "$rv"
    fi
    echo -n "$rs"
}

peval_noout()
{
    local rs rv
    rs=$(eval "${1}" 2>&1 1> /dev/null); rv="${?}"
    if [ "$rv" != 0 ]; then
        perrorl "${@:2:${#}}" "${1}:" "[$rv]:" "$rs"
        return "$rv"
    fi
}

die()
{
    local eno="${1:-0}"; shift
    [ "${#}" -gt 0 ] && perrorl "${@:-}"
    exit "$eno"
}

die_if_levels()
{
    if [[ "$BASH_SUBSHELL" -gt 0 ]] || [[ "$SHLVL" -gt 1 ]]; then
        die "${@}"
    fi
    return "${1:-0}"
}

# Display the rotating cursor
spin()
{
    local spinner="/-\|"
    while :; do
        for (( i = 0; i < ${#spinner}; i++ )); do
            printf '%s\r' "${spinner:$i:1}"
            sleep "${1:-1}"
        done
    done
}
