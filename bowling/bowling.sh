#!/usr/bin/env bash

# defaults
FirstThrowOfFrame="true"        # boolean "true" during first throw, "" during second
Spare=0                         # boolean that doubles value of next throw
Strike=0                        # boolean held until first throw is scored,
                                # then toggled and make SPARE true to add the value of second throw
ScoringComplete=""              # true when all ten frames have been scored
(( FirstThrowValue=0 ))         # for non-strike frames, the first throw captured for use during second throw of frame
(( Frame=0 ))                   # incremental value of current frame
(( Score=0 ))                   # sum of all frame scores

main() {
    for t in $@;do
        if (( $t < 0 ));then
            echo "Negative roll is invalid"
            exit 1
        elif (( $t > 10 ));then
            echo "Pin count exceeds pins on the lane"
            exit 1
        elif [[ ${ScoringComplete} ]];then
            echo "Cannot roll after game is over"
            exit 1
        fi
        roll $t
    done
    score
}

roll() {
    (( Throw=$1 ))

    if [[ ${FirstThrowOfFrame} ]];then
        (( Frame=$Frame+1 )) && FirstThrowOfFrame=""
        if (( ${Frame} <= 10 )); then
            (( Score=$Score+$Throw ))
        fi

        while [[ ${Spare} -gt 0 ]];do
            (( Score=$Score+$Throw ))
            (( Spare=${Spare}-1 ))
        done
        if [[ ${Strike} -gt 0 ]];then
            (( Spare=$Spare+$Strike ))
            (( Strike=0 ))
        fi

        if (( $Throw == 10 ));then
            if (( $Frame <= 10 ));then
                (( Spare=$Spare+1 ))
                (( Strike=1 ))
            fi
            FirstThrowOfFrame="true"
        fi
        (( FirstThrowValue=$Throw ))
        if (( $Frame > 10 && ($Spare == 0 && $Strike == 0) ));then
            ScoringComplete="true"
        fi
    else
        (( Score=$Score+$Throw ))

        if (( $Frame <= 10 ));then
            while [[ ${Spare} -gt 0 ]];do
                (( Score=$Score+$Throw ))
                (( Spare=${Spare}-1 ))
            done
            if [[ ${Strike} -gt 0 ]];then
                (( Spare=$Spare+$Strike ))
                (( Strike=0 ))
            fi
        fi
        if (( $FirstThrowValue+$Throw == 10 ));then
            (( Spare=${Spare}+1 ))
            (( Strike=0 ))
        elif (( $FirstThrowValue+$Throw > 10 ));then
            echo "Pin count exceeds pins on the lane"
            exit 1
        fi
        FirstThrowOfFrame="true"
        if (( ($Frame == 10 && ($Spare == 0 && $Strike == 0)) || $Frame > 10));then
            ScoringComplete="true"
        fi
    fi
}

score() {
    if [[ ${Frame} -ge 10 && ${ScoringComplete} ]];then
        echo ${Score}
    else
        echo "Score cannot be taken until the end of the game"
        exit 1
    fi
}

# call main with all of the positional arguments
main "$@"
