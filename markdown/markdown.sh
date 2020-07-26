#!/usr/bin/env bash

# Changes marked with ####
#### Reformat code to make it more readable.

while IFS= read -r line; do
  #### removed loop that does nothing
  if [[ $line =~ ^(.+)__(.*) ]]; then
    post=${BASH_REMATCH[2]}
    pre=${BASH_REMATCH[1]}
    if [[ $pre =~ ^(.*)__(.+) ]]; then
      printf -v line "%s<strong>%s</strong>%s" "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" "$post"
    fi
  fi

  #### removed line with echo piped to grep and put logic directly in if statement
  if [[ $line =~ ^\* ]]; then
    #### double quote variable $inside_a_list, removed unneeded char X
    if [ "$inside_a_list" != yes ]; then
      h="$h<ul>"
      inside_a_list=yes
    fi

    while [[ $line == *_*?_* ]]; do
      one=${line#*_}
      two=${one#*_}
      #### changed grouping in if test, replacing -a with &&
      if [ ${#two} -lt ${#one} ] && [ ${#one} -lt ${#line} ]; then
        line="${line%%_$one}<em>${one%%_$two}</em>$two"
      fi
    done
    h="$h<li>${line#??}</li>"

  else
    #### double quote variable $inside_a_list, removed unneeded char X
    if [ "$inside_a_list" = yes ]; then
      h="$h</ul>"
      inside_a_list=no
    fi

    n=$(expr "$line" : "#\{1,\}")
    ##### double quote variable $n
    if [ "$n" -gt 0 ]; then
      while [[ $line == *_*?_* ]]; do
        s=${line#*_}
        t=${s#*_}
        #### changed grouping in if test, replacing -a with &&
        if [ ${#t} -lt ${#s} ] && [ ${#s} -lt ${#line} ]; then
          line="${line%%_$s}<em>${s%%_$t}</em>$t"
        fi
      done
      HEAD=${line:n}
      #### removed unneeded while loop
      [[ $HEAD = ' '* ]] && HEAD=${HEAD# }
      h="$h<h$n>$HEAD</h$n>"
    else
      #### removed unneeded grep and put matching logic into [[]]
      [[ "$line" =~ _..*_ ]] &&
        line=$(echo "$line" | sed -E 's,_([^_]+)_,<em>\1</em>,g')
      h="$h<p>$line</p>"
    fi
  fi
done <"$1"

#### double quote variable $inside_a_list, removed unneeded char X
if [ "$inside_a_list" = yes ]; then
  h="$h</ul>"
fi

echo "$h"
