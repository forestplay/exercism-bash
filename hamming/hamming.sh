#!/usr/bin/env bash

main() {
  if (( $# != 2 ));then
    echo "Usage: hamming.sh <string1> <string2>"
    exit 1
  fi

  local string1=$1
  local string2=$2

  local size1=${#string1}
  local size2=${#string2}

  if (( size1 != size2 )); then
    echo "left and right strands must be of equal length"
    exit 1
  fi

  (( hammingDistance = 0 ))
  for ((i = 0; i < ${#string1}; i++)); do
    if [[ "${string1:$i:1}" != "${string2:$i:1}" ]]; then
      (( hammingDistance++ ))
    fi
  done

  echo "$hammingDistance"

}

# call main with all of the positional arguments
main "$@"
