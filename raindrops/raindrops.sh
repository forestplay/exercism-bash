#!/usr/bin/env bash

for value do
  (("$value" % 3 == 0)) && outString+="Pling"
  (("$value" % 5 == 0)) && outString+="Plang"
  (("$value" % 7 == 0)) && outString+="Plong"
  echo ${outString:-"$value"}
done
