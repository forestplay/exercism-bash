#!/usr/bin/env bash

main () {
  echo "$1" | rev
}

# call main with all of the positional arguments
main "$@"
