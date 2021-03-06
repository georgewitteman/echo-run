#!/bin/sh

if [ "$#" -eq 0 ]; then
  return
fi

_echo_run_current_value=''

for _echo_run_current_arg in "$@"; do
  if [ -n "${_echo_run_current_value:++}" ]; then
    _echo_run_current_value="${_echo_run_current_value} "
  fi

  _echo_run_arg_needs_quotes=
  case ${_echo_run_current_arg:-=} in
    [=~]*) _echo_run_arg_needs_quotes=1 ;;
  esac

  _echo_run_current_arg_temp="$_echo_run_current_arg"

  while _echo_run_part_before_single_quote=${_echo_run_current_arg_temp%%\'*}; do
    _echo_run_part_needs_quotes=

    case $_echo_run_part_before_single_quote in
      *[!-+=~@%/:.,_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*)
        _echo_run_part_needs_quotes=1
        ;;
    esac

    if [ -z "${_echo_run_arg_needs_quotes}" ] && [ -z "${_echo_run_part_needs_quotes}" ]; then
      _echo_run_current_value="${_echo_run_current_value}${_echo_run_part_before_single_quote}"
    else
      _echo_run_current_value="${_echo_run_current_value}'${_echo_run_part_before_single_quote}'"
    fi

    if [ x"${_echo_run_part_before_single_quote}" = x"${_echo_run_current_arg_temp}" ]; then
      break
    fi

    _echo_run_current_value="${_echo_run_current_value}\'"
    _echo_run_current_arg_temp="${_echo_run_current_arg_temp#*\'}"
  done
done

if [ -t 1 ]; then
  printf "\033[1;34m" >&2
fi
printf '$ %s\n' "${_echo_run_current_value}" >&2
if [ -t 1 ]; then
  printf "\033[0m" >&2
fi

unset _echo_run_arg_needs_quotes _echo_run_current_arg _echo_run_current_arg_temp
unset _echo_run_current_value _echo_run_part_before_single_quote _echo_run_part_needs_quotes

"$@"
