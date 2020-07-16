#!/usr/bin/env bash

main () {
    outString=""
    for value in $@; do
        if (( $value % 3 == 0 ));then
            outString=${outString}"Pling"
        fi
        if (( $value % 5 == 0 ));then
            outString=${outString}"Plang"
        fi
        if (( $value % 7 == 0 ));then
            outString=${outString}"Plong"
        fi

        if [[ $outString ]];then
            echo $outString
        else
            echo $value
        fi
    done
}

main "$@"
