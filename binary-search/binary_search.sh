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
  local startIndex=$2
  local stopIndex=$3
  IFS=', -_*' read -r -a array <<<"$4"
  while ((startIndex <= stopIndex)); do
    ((midIndex = startIndex + (stopIndex - startIndex) / 2))

    if [[ $debug == true ]]; then
      echo "-- Start bin search --"
      echo "$searchValue" "$startIndex" "$midIndex" "$stopIndex"
      for value in "${array[@]:$startIndex:$stopIndex}"; do
        echo -n "$value "
      done
      echo
    fi

    if ((searchValue == array[midIndex])); then
      echo "$midIndex"
      return
    elif ((searchValue < array[midIndex])); then
      ((stopIndex = midIndex - 1))
    else
      ((startIndex = midIndex + 1))
    fi
  done
  echo -1
}

main() {
  local searchValue="$1"
  if [[ $2 == "" ]]; then
    echo -1
    exit 1
  fi
  IFS=', -_*' read -r -a array <<<"$2"

  local startValue=0
  ((stopValue = ${#array[@]} - 1))
  binarySearch "$searchValue" "$startValue" "$stopValue" "${array[*]}"
}

# call main with all of the positional arguments
main "$@"
