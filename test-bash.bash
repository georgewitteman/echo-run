#!/bin/bash

set -o posix
__test_sh_vars="$(set | grep _echo_run_)"
set +o posix

eval "
echo-run() {
$(< ./echo-run.sh)
}
"

echo-run "$@"

set -o posix
if [[ "$(set | grep _echo_run_)" != "$vars" ]]; then
  echo "Failed to unset variables."
fi
set +x posix
