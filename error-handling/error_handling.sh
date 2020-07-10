#!/usr/bin/env bash

usage="Usage: error_handling.sh <person>"

main () {
if [[ $# -eq 0 ]];then
  echo $usage
  exit 1
elif [[ $# -gt 1 && $2 != "and" ]];then
  echo $usage
  exit 1
fi

echo "Hello, "$*

}

# call main with all of the positional arguments
main "$@"

