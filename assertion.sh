#!/usr/bin/env bash

# Make sure this script is sourced only once
if ! readonly __SHCOMMONS_ASSERTION_SH_SOURCED= &> /dev/null; then
    return
fi

# __abort <condition> <message> <filename> <lineno>
__abort()
{
    local msg="Assertion failed:"
    if is_set "${3}" && is_set "${4}"; then
        msg="$msg File \"${3}\", Line ${4}:"
    fi
    msg="$msg ${1}"
    is_set "${2}" && msg="${msg}: ${2}"
    [ "$ABORT_WHEN_ASSERT_FAILED" = true ] && msg="$msg  Aborting."
    perrorl "$msg"
    [ "$ABORT_WHEN_ASSERT_FAILED" = true ] && exit "$ENO_ASSERT_FAILED"
    return "$ENO_ASSERT_FAILED"
}

assert()
{
    if [ "${#}" -lt 1 ]; then
        return "$ENO_PARAM"
    fi
    local expr="${1}"; shift
    if [ ! ${expr} ]; then
        __abort "\"[ ${expr} ]\"" "${@}"
        return "${?}"
    fi
}

assert_eq()
{
    if [ "${#}" -lt 2 ]; then
        return "$ENO_PARAM"
    fi
    local expected="${1}"
    local actual="${2}"
    shift 2
    assert "${expected} -eq ${actual}" "${@}"
}

assert_ne()
{
    if [ "${#}" -lt 2 ]; then
        return "$ENO_PARAM"
    fi
    local expected="${1}"
    local actual="${2}"
    shift 2
    assert "${expected} -ne ${actual}" "${@}"
}
