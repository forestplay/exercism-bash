#!/usr/bin/env bash

usage="Usage: error_handling.sh <person>"

main () {
if (( $# != 1 ));then
  echo "$usage"
  exit 1
fi

echo "Hello, $1"

}

# call main with all of the positional arguments
main "$@"
