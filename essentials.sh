#!/usr/bin/env bash

# Make sure this script is sourced only once
if ! readonly __SHCOMMONS_ESSENTIALS_SH_SOURCED= &> /dev/null; then
    return
fi

declare -r ENO_ERROR=1              # General error
declare -r ENO_EACCESS=96           # The file permissions do not allow the attempted operation
declare -r ENO_ENOENT=97            # No such file or directory
declare -r ENO_PARAM=98             # Not enough parameters passed
declare -r ENO_ASSERT_FAILED=99
declare -r ENO_ILLEGAL_CMD=127      # Command not found

is_dir()
{
    [ -d "${1}" ]
}

is_file()
{
    [ -f "${1}" ]
}

is_exists()
{
    [ -e "${1}" ]
}

can_read()
{
    [ -r "${1}" ]
}

can_write()
{
    [ -w "${1}" ]
}

can_exec()
{
    [ -x "${1}" ]
}

is_empty()
{
    [ -z "${1}" ]
}

is_set()
{
    [ -n "${1}" ]
}

is_number()
{
    [[ "${1}" =~ ^-?[0-9]+$ ]]
}

is_positive_number()
{
    [[ "${1}" =~ ^[0-9]+$ ]]
}

is_negative_number()
{
    [[ "${1}" =~ ^-[0-9]+$ ]]
}

is_root()
{
    if is_number "${1:-$UID}"; then
        [ "${1:-$UID}" -eq 0 ]
    else
        [ "$(id -u ${1} 2> /dev/null)" = 0 ]
    fi
}

has_command()
{
    command -v "${1}" &> /dev/null
}

is_executable()
{
    eval "${1}" &> /dev/null
}

# Check module is installed in Python
is_python_module()
{
    is_executable "python -c 'import ${1}'"
}

is_python2()
{
    [ "$(python -c 'import sys; print(sys.version_info[0])' 2> /dev/null)" = 2 ]
}

is_python3()
{
    [ "$(python -c 'import sys; print(sys.version_info[0])' 2> /dev/null)" = 3 ]
}

# Check if a function exists
is_fn_exists()
{
    declare -F "$1" > /dev/null;
}

to_lower()
{
    echo "${@}" | tr '[A-Z]' '[a-z]'
}

to_upper()
{
    echo "${@}" | tr '[a-z]' '[A-Z]'
}

# Join elements with delimiter
join_by()
{
    local d="${1}"; shift; echo -n "$1"; shift; printf "%s" "${@/#/$d}";
}

# Absolute value
abs()
{
    [ "${1}" -lt 0 ] && echo "$((-${1}))" || echo "${1}"
}

# Absolute path
abspath()
{
    readlink -nf "${1}" 2> /dev/null
}

# Absolute dir
absdir()
{
    dirname -z $(readlink -nf "${1}") 2> /dev/null
}
