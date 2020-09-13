#!/bin/zsh

__test_sh_vars="$(set | grep _echo_run_)"

eval "
echo-run () {
$(< ./echo-run.sh)
}
"

echo-run "$@"

if [[ "$(set | grep _echo_run_)" != "$vars" ]]; then
  echo "Failed to unset variables."
fi
