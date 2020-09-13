# echo-run and echo-eval

Two scripts for printing commands to the console before running them. I use it to write scripts to make it easier to see what's actually being run during the script. Also makes sharing the output of a script with others easier.

## Installation

### Copy the scripts to your `$PATH`
```sh
cp ./echo-run.sh /usr/local/bin/echo-run
cp ./echo-eval.sh /usr/local/bin/echo-eval
```

### Create autoloaded functions for your shell (optional)
```bash
# In .bashrc or .zshrc
echo-run() {
  eval "echo-run() {
    $(< /usr/local/bin/echo-run)
  }"
  echo-run "$@"
}

echo-eval() {
  eval "echo-eval() {
    $(< /usr/local/bin/echo-eval)
  }"
  echo-eval "$@"
}
```
