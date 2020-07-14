#!/usr/bin/env bash

colorToValue() {
  declare -A colors=( \
    ["BLACK"]=0 \
    ["BROWN"]=1 \
    ["RED"]=2 \
    ["ORANGE"]=3 \
    ["YELLOW"]=4 \
    ["GREEN"]=5 \
    ["BLUE"]=6 \
    ["VIOLET"]=7 \
    ["GREY"]=8 \
    ["WHITE"]=9)

  value="${colors[${1^^}]}"

  if [[ -z "$value" ]]; then
    echo "invalid color"
  else
    echo "$value"
  fi
}

valueToExponent() {
  case "$1" in
  0)
    echo ""
    ;;
  1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9)
    for i in $(seq 1 $1); do
      echo -n "0"
    done
    echo
    ;;
  *)
    echo "invalid value"
    ;;
  esac
}

value=$(colorToValue "$1")$(colorToValue "$2")$(valueToExponent $(colorToValue "$3"))" ohms"
value=${value//000000000 / giga}
value=${value//000000 / mega}
value=${value//000 / kilo}
value=$(echo $value | sed 's/^0//')

if [[ ! $value =~ ^[0-9]+\ (kilo|mega|giga)?ohms ]]; then
  echo "invalid color"
  exit 1
fi

echo "${value}"
