#!/usr/bin/env bash

# Set defaults - empty string == false
printLineNumbers="" # if true, print the line numbers of each matching line.
printNamesOnly=""   # if true, print only the names of files that contain at least one matching line.
caseSensitive=""    # if true, match line using a case-insensitive comparison.
invertPrint=""      # if true, invert the program -- collect all lines that fail to match the pattern.
matchLine=""        # if true, only match entire lines, instead of lines that contain a match.
multipleFiles=""    # if true, output file name before matching line.
debug=""            # if true, detailed messages throughout script

while getopts ":dnlivx" opt; do
  case $opt in
  n) printLineNumbers="true" ;;
  l) printNamesOnly="true" ;;
  i)
    caseSensitive="true"
    shopt -s nocasematch
    ;;
  v) invertPrint="true" ;;
  x) matchLine="true" ;;
  d) debug="true" ;;
  \?)
    echo "$(basename "$0"): Invalid option: -$OPTARG" >&2
    exit 1
    ;;
  esac
done
shift $((OPTIND - 1))

match() {
  [[ ($invertPrint && ! $1 =~ $2) || (! $invertPrint && $1 =~ $2) ]]
}

main() {
  local regex=$1
  shift
  [[ $matchLine ]] && regex="^$regex$"
  (($# > 1)) && multipleFiles="true"

  for file in "$@"; do
    ((lineNumber = 0))
    while IFS= read -r line; do
      ((lineNumber = lineNumber + 1))
      if match "$line" "$regex"; then
        if [[ $printNamesOnly ]]; then
          printf "%s\n" "$file"
          break
        fi
        [[ $multipleFiles ]] && printf '%s' "$file:"
        [[ $printLineNumbers ]] && printf '%s' "$lineNumber:"
        printf '%s\n' "$line"
      fi
    done <"$file"
  done
}

if [[ $debug ]]; then
  echo "##### Starting $(basename "$0")"
  echo "PrintLineNumbers: $([[ $printLineNumbers ]] && echo $printLineNumbers || echo false)"
  echo "  PrintNamesOnly: $([[ $printNamesOnly ]] && echo $printNamesOnly || echo false)"
  echo "   CaseSensitive: $([[ $caseSensitive ]] && echo $caseSensitive || echo false)"
  echo "     InvertPrint: $([[ $invertPrint ]] && echo $invertPrint || echo false)"
  echo "       MatchLine: $([[ $matchLine ]] && echo $matchLine || echo false)"
  echo "      parameters: $*"
  echo
fi

# call main with remaining positional arguments
main "$@"
