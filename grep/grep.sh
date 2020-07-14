#!/usr/bin/env bash

# Set defaults
PRINT_LINE_NUMBERS=""   # if true, print the line numbers of each matching line.
PRINT_NAMES_ONLY=""     # if true, print only the names of files that contain at least one matching line.
CASE_SENSITIVE=""       # if true, match line using a case-insensitive comparison.
INVERT_PRINT=""         # if true, invert the program -- collect all lines that fail to match the pattern.
MATCH_LINE=""           # if true, only match entire lines, instead of lines that contain a match.
MULTIPLE_FiLES=""       # if true, output file name before matching line.
DEBUG=""                # if true, detailed messages throughout script

while getopts ":dnlivx" opt; do
  case $opt in
    n)
    PRINT_LINE_NUMBERS="true"
    ;;
    l)
    PRINT_NAMES_ONLY="true"
    ;;
    i)
    CASE_SENSITIVE="true"
    shopt -s nocasematch
    ;;
    v)
    INVERT_PRINT="true"
    ;;
    x)
    MATCH_LINE="true"
    ;;
    d)
    DEBUG="true"
    ;;
    \?)
    echo $(basename "$0")": Invalid option: -$OPTARG" >&2
    exit 1
    ;;
  esac
done
shift $((OPTIND-1))


main () {
  regex=$1
  shift
  (( $# > 1 )) && MULTIPLE_FiLES="true"

  for file in "$@";do
    (( lineNumber=0 ))
    while IFS= read -r line; do
      (( lineNumber=lineNumber+1 ))
      line=$(tr -dc '[[:print:]]' <<< "$line")
      if [[ (! $MATCH_LINE && (($INVERT_PRINT && ! $line =~ $regex) || (! $INVERT_PRINT && $line =~ $regex)))
      || ($MATCH_LINE && (($INVERT_PRINT && $line != "$regex") || (! $INVERT_PRINT && $line == "$regex"))) ]];then
        if [[ $PRINT_NAMES_ONLY ]];then
          printf "%s\n" "$file"
          break
        fi
        [[ $MULTIPLE_FiLES ]] && printf '%s' $file":"
        [[ $PRINT_LINE_NUMBERS ]] && printf '%s' $lineNumber":"
        printf '%s\n' "$line"
      fi
    done < "$file"
  done
}

if [[ $DEBUG ]];then
  echo "##### Starting "$(basename "$0")
  echo "PRINT_LINE_NUMBERS:" $([[ $PRINT_LINE_NUMBERS ]] && echo $PRINT_LINE_NUMBERS || echo "false")
  echo "  PRINT_NAMES_ONLY:" $([[ $PRINT_NAMES_ONLY ]] && echo $PRINT_NAMES_ONLY || echo "false")
  echo "    CASE_SENSITIVE:" $([[ $CASE_SENSITIVE ]] && echo $CASE_SENSITIVE || echo "false")
  echo "      INVERT_PRINT:" $([[ $INVERT_PRINT ]] && echo $INVERT_PRINT || echo "false")
  echo "        MATCH_LINE:" $([[ $MATCH_LINE ]] && echo $MATCH_LINE || echo "false")
  echo "        parameters:" "$@"
  echo
fi

# call main with remaining positional arguments
main "$@"
