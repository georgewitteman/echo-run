#!/usr/bin/env zsh

B="\033[1;34m"
C="\033[0m"

has_failures=

run-case() {
  echo "Running case: $1"
  local arg="$1"
  local expected="$2"
  if [[ -z "$expected" ]]; then
    expected="$(get-expected echo "$arg")"
  fi
  run-case-zsh "$arg" "$expected"
  run-case-bash "$arg" "$expected"
  run-case-dash "$arg" "$expected"
}

run-case-zsh() {
  local arg="$1"
  local expected="$2"
  local output="$(./test-zsh.zsh echo "$arg" 2>&1)"
  if [[ "$expected" != "$output" ]]; then
    has_failures=1
    echo "=== Error ZSH ==="
    echo "--- Expected ---"
    echo "$expected"
    echo "--- Actual ---"
    echo "$output"
    echo
  fi
}

run-case-bash() {
  local arg="$1"
  local expected="$2"
  local output="$(./test-bash.bash echo "$arg" 2>&1)"
  if [[ "$expected" != "$output" ]]; then
    has_failures=1
    echo "=== Error Bash ==="
    echo "--- Expected ---"
    echo "$expected"
    echo "--- Actual ---"
    echo "$output"
    echo
  fi
}

run-case-dash() {
  local arg="$1"
  local expected="$2"
  local output="$(./test-dash.dash echo "$arg" 2>&1)"
  if [[ "$expected" != "$output" ]]; then
    has_failures=1
    echo "=== Error Dash ==="
    echo "--- Expected ---"
    echo "$expected"
    echo "--- Actual ---"
    echo "$output"
    echo
  fi
}

get-expected() {
  echo "\$ ${(q-)@}"
  "$@"
}

run-eval-case() {
  echo "Running eval case: $@"
  run-eval-case-zsh "$@"
  run-eval-case-bash "$@"
  run-eval-case-dash "$@"
}

run-eval-case-zsh() {
  local output="$(./test-eval-zsh.zsh "$@" 2>&1)"
  local expected="$(get-eval-expected "$@")"
  if [[ "$output" != "$expected" ]]; then
    has_failures=1
    echo "=== Error Eval ZSH ==="
    echo "--- Expected ---"
    echo "$expected"
    echo "--- Actual ---"
    echo "$output"
    echo
  fi
}

run-eval-case-bash() {
  local output="$(./test-eval-bash.bash "$@" 2>&1)"
  local expected="$(get-eval-expected "$@")"
  if [[ "$output" != "$expected" ]]; then
    has_failures=1
    echo "=== Error Eval Bash ==="
    echo "--- Expected ---"
    echo "$expected"
    echo "--- Actual ---"
    echo "$output"
    echo
  fi
}

run-eval-case-dash() {
  local output="$(./test-eval-dash.dash "$@" 2>&1)"
  local expected="$(get-eval-expected "$@")"
  if [[ "$output" != "$expected" ]]; then
    has_failures=1
    echo "=== Error Eval Dash ==="
    echo "--- Expected ---"
    echo "$expected"
    echo "--- Actual ---"
    echo "$output"
    echo
  fi
}

get-eval-expected() {
  echo "\$ ${@}"
  eval "$@"
}

run-nested-case() {
  echo "Running nested case: ${@}"
  local output="$(./test-nested-dash.dash echo_run "$@" 2>&1)"
  local expected="$(get-dash-nested-expected "$@")"
  if [[ "$output" != "$expected" ]]; then
    has_failures=1
    echo "=== Error Nested Run Dash ==="
    echo "--- Expected ---"
    echo "$expected"
    echo "--- Actual ---"
    echo "$output"
    echo
  fi
}

get-dash-nested-expected() {
  echo "\$ echo_run ${(q-)@}"
  echo "\$ ${(q-)@}"
  "$@"
}

echo "=== get-expected =============="
get-expected echo 'foo bar'
echo "=== get-eval-expected ========="
get-eval-expected echo "\$'foo\\\nbar baz'" '| grep "bar"'
echo "=== get-dash-nested-expected==="
get-dash-nested-expected echo 'foo bar'
echo "==============================="

run-case foo

run-case "foo bar"

run-case "foo ' bar"

run-case '!foo' "\$ echo '!foo'
!foo"

run-case '$foo'

run-case '${foo}'

run-case "'foo \" bar'"

run-case 'foo=bar'

run-case '=foo'

run-case '~foo'

run-case 'foo~bar'

run-case "$USER"

run-case "bl'~ah"

run-case ''

run-case '|	& ; < > ( ) $ ` \ "'

run-case $'foo\tfoo'

run-case '"
"'

run-case '* ? [ # ˜ ~ = %'

run-case '*foo*'

run-case '?foo?'

run-case '[foo]'

run-case '[[foo]]'

run-case '#foo'

run-case '˜foo˜' "\$ echo '˜foo˜'
˜foo˜"

run-case '=foo='

run-case '%foo%'

run-case '\/\/'

run-case '//'

run-case '\
  foo'

run-case ' '

run-case 'echo foo && echo bar'

run-case 'echo foo || echo bar'

run-case '$(foo)'

run-case '`foo`'

run-case '{'

run-case '}'

run-case '$@'

run-case '$*'

run-case '$#'

run-case '$?'

run-case '$-'

run-case '$$'

run-case '$!'

run-case '$0'

run-case '-v'

run-case '-n'

run-eval-case 'echo "foo bar";' 'echo baz'

run-eval-case 'echo "$USER" | grep "$USER"'

run-eval-case 'echo "foo bar"' '>/dev/null'

run-eval-case echo foo bar

run-nested-case echo foo

run-nested-case echo '-v'

run-nested-case echo '-n'

if [[ -n "$(./test-dash.dash)" ]]; then
  has_failures=1
  echo "Failure to ignore no args in dash"
else
  echo "dash ignored args ✔️"
fi

if [[ -n "$(./test-bash.bash)" ]]; then
  has_failures=1
  echo "Failure to ignore no args in bash"
else
  echo "bash ignored args ✔️"
fi

if [[ -n "$(./test-zsh.zsh)" ]]; then
  has_failures=1
  echo "Failure to ignore no args in zsh"
else
  echo "zsh ignored args ✔️"
fi

if [[ -n "$has_failures" ]]; then
  printf "\033[31mTests failed!\033[0m\n"
else
  echo
  printf "\033[32mTests passed!\033[0m\n"
fi
