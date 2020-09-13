#!/bin/bash

eval "
echo-eval() {
$(< ../echo-eval.sh)
}
"

echo-eval "$@"
