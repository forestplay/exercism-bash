#!/usr/bin/env bash

colorToValue () {
  case ${1^^} in
    BLACK)
      echo 0
      ;;
    BROWN)
      echo 1
      ;;
    RED)
      echo 2
      ;;
    ORANGE)
      echo 3
      ;;
    YELLOW)
      echo 4
      ;;
    GREEN)
      echo 5
      ;;
    BLUE)
      echo 6
      ;;
    VIOLET)
      echo 7
      ;;
    GREY)
      echo 8
      ;;
    WHITE)
      echo 9
      ;;
    *)
      echo "invalid color"
      ;;
  esac
}

value=$(colorToValue "$1")$(colorToValue "$2")

if [[ ! $value =~ ^[0-9]+$ ]];then
  echo "invalid color"
  exit 1
else
  echo "$value"
fi
