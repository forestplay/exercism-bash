#!/usr/bin/env bash

main() {
  IFS=', -_*' read -r -a array <<<$1
  for word in "${array[@]}"; do
    echo -n "${word:0:1}"
  done | tr a-z A-Z
}

# call main with all of the positional arguments
main "$@"
