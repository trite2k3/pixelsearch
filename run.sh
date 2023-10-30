#!/bin/bash

function limitedsearch
{
    #Run the binary
    pixelsearch=$(./limitedsearch $SRed $SGreen $SBlue $ColorDelta $CDelta $SX $SY $EX $EY)

    #only do stuff if pixel is found
    if [ "$pixelsearch" = "No" ]
        then
        echo "Pixel not found."
        return 1

        else
        #split the output into two variables
        IFS=',' read -ra values <<< "$(echo "$pixelsearch" | awk -F',' '{print $1,$2}')"

        echo $IFS

        #Assign
        varX="${values[0]}"
        varY="${values[1]}"

        #echo $varX
        #echo $varY
        return 0
    fi
}

#use sleep 3; xdotool getmouselocation to find mousepos
SRed=0
SGreen=0
SBlue=0
ColorDelta=0w
CDelta=10
SX=4991
SY=77
EX=1
EY=1

if limitedsearch "$SRed, $SGreen, $SBlue, $ColorDelta, $CDelta, $SX, $SY, $EX, $EY"
then
    #move mouse to pos
    #echo "Moving mouse to "$varX$varY
    #xdotool mousemove $varX $varY
    echo "We are in Stormwind Keep."
else
    echo "We are probably in Alterac Valley."
    while sleep 60
    do
        xdotool key Down
        sleep 0.1
        xdotool key Down
        sleep 0.1
        xdotool key Down
        sleep 0.1
        xdotool key Down
        sleep 0.1
        xdotool key Down
        sleep 0.1
    done
fi

