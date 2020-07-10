#!/usr/bin/env bash

  main () {
    echo One for "${1:-you}", one for me.
  }

# call main with all of the positional arguments
main "$@"
