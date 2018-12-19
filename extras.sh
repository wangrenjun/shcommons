#!/usr/bin/env bash

# Make sure this script is sourced only once
if ! readonly __SHCOMMONS_EXTRAS_SH_SOURCED= &> /dev/null; then
    return
fi

# Resolve host name to IP address
resolve_hostname_to_ip()
{
    if has_command dig; then
        echo "$(dig +short ${1} 2> /dev/null)"
    elif has_command host; then
        echo "$(host ${1} 2> /dev/null | awk '/has address/{print $4}')"
    else
        echo "$(nslookup ${1} 2> /dev/null | awk '/^Address: / { print $2 }')"
    fi
}

ssh_version()
{
    echo $(ssh -V 2>&1 | awk 'BEGIN{ FS="_"; } { print $2 }' | awk 'BEGIN { FS=","; } { print $1 }')
}

# The parameter format is [user@]domain[:port]
extract_parts_from_userdomain()
{
    OIFS="$IFS"
    IFS='@:' read -r -a arr <<< "${1}"
    IFS="$OIFS"
    declare -A parts=()
    case "${#arr[@]}" in
    1 ) parts+=( ['hostname']="${arr[0]}" ) ;;
    2 ) if $(echo "${1}" | grep '@' &> /dev/null); then
            parts+=( ['username']="${arr[0]}" )
            parts+=( ['hostname']="${arr[1]}" )
        else
            parts+=( ['hostname']="${arr[0]}" )
            parts+=( ['port']="${arr[1]}" )
        fi ;;
    3 ) parts+=( ['username']="${arr[0]}" )
        parts+=( ['hostname']="${arr[1]}" )
        parts+=( ['port']="${arr[2]}" ) ;;
    * ) return "$ENO_PARAM" ;;
    esac
    echo "$(declare -p parts)"
}

# Non-blocking read input
nbread_input()
{
    [ -t 0 ] && stty -echo -icanon time 0 min 0
    while read line; do
        echo "$line"
    done < "/dev/stdin"
    [ -t 0 ] && stty sane  # Reset to classic behavior: blocking the read input
}

kill_all_by_name()
{
    if has_command killall; then
        killall "${1}" &> /dev/null
    else
        ps -e | grep "${1}" | awk '{print $1;}' | xargs kill -9 &> /dev/null
    fi
}

# Interrupted script by SIGHUP SIGINT SIGQUIT SIGTERM
sigtrap()
{
    trap 'perrorl "Interrupted by signal" >&2; exit' 1 2 3 15
}
