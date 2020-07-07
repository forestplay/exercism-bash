#!/usr/bin/env bash

main () {
  year=$1
  result=false
  
  if (( year % 4 == 0 ));then
    if (( year % 100 == 0 ));then
      if (( year % 400 == 0 ));then
        result=true
      fi
    else
      result=true
    fi
  fi
  
  echo $result
}

if [[ $# != 1 || ! $1 =~ ^[0-9]+$ ]];then
  echo "Usage: leap.sh <year>"
  exit 1
fi

main "$@"
