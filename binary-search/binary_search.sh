#!/usr/bin/env bash

debug=false # if true, detailed messages throughout script

while getopts ":d" opt; do
  case $opt in
  d) debug=true ;;
  \?)
    echo "$(basename "$0"): Invalid option: -$OPTARG" >&2
    exit 1
    ;;
  esac
done
shift $((OPTIND - 1))

binarySearch() {
  local searchValue=$1
  local leftIndex=0
  local midIndex=0
  local rightIndex=0
  local array
  IFS=', -_*' read -r -a array <<<"$2"
  ((rightIndex = ${#array[@]} - 1))

  while ((leftIndex <= rightIndex)); do
    ((midIndex = leftIndex + (rightIndex - leftIndex) / 2))

    if [[ $debug == true ]]; then
      echo "-- Start binary search loop --"
      echo "$searchValue" "$leftIndex" "$midIndex" "$rightIndex"
      for value in "${array[@]:$leftIndex:$rightIndex}"; do
        echo -n "$value "
      done
      echo
    fi

    if ((searchValue == array[midIndex])); then
      echo "$midIndex"
      return
    elif ((searchValue < array[midIndex])); then
      ((rightIndex = midIndex - 1))
    else
      ((leftIndex = midIndex + 1))
    fi
  done
  echo -1
}

if [[ $2 == "" ]]; then
  echo -1
  exit 1
fi
binarySearch "$1" "$2"
