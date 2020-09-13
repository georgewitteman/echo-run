#!/bin/zsh

eval "
echo-eval () {
$(< ../echo-eval.sh)
}
"

echo-eval "$@"
