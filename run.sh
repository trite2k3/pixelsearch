#!/bin/bash

#time to focus window
sleep 2

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

function joinbg
{
    #trying to join queue
    echo "targeting npc"
    sleep 0.3
    xdotool key Return
    sleep 0.2
    xdotool key slash
    sleep 0.1
    xdotool key t
    sleep 0.1
    xdotool key a
    sleep 0.1
    xdotool key r
    sleep 0.1
    xdotool key g
    sleep 0.1
    xdotool key e
    sleep 0.1
    xdotool key t
    sleep 0.1
    xdotool key space
    sleep 0.1
    xdotool key T
    sleep 0.1
    xdotool key h
    sleep 0.1
    xdotool key e
    sleep 0.1
    xdotool key l
    sleep 0.1
    xdotool key m
    sleep 0.1
    xdotool key a
    sleep 0.1
    xdotool key n
    sleep 0.1
    xdotool key Return
    sleep 0.1
    xdotool key 0
    sleep 0.1
    xdotool key 0
    sleep 0.1
    xdotool key 0
    sleep 1
    #join bg and accept q
    #npc chat
    sleep 3
    echo "opening npc chat"
    xdotool mousemove --sync 2825 449
    xdotool click 1
    sleep 3
    #join battle
    echo "pressing join button"
    xdotool mousemove --sync 2900 890
    xdotool click 1
    sleep 1
}

function enterbattle
{
    #trying to join bq pop
    xdotool mousemove --sync 3645 322
    sleep 1
    xdotool click 1
}

#use sleep 3; xdotool getmouselocation to find mousepos
#SRed=0
#SGreen=0
#SBlue=0
#ColorDelta=0w
#CDelta=10
#SX=4991
#SY=77
#EX=1
#EY=1

SRed=0
SGreen=0
SBlue=0
ColorDelta=0
CDelta=3
SX=4960
SY=63
EX=1
EY=1

while true
do
    if limitedsearch "$SRed, $SGreen, $SBlue, $ColorDelta, $CDelta, $SX, $SY, $EX, $EY"
    then
        #move mouse to pos
        #echo "Moving mouse to "$varX$varY
        #xdotool mousemove $varX $varY
        echo "We are in Stormwind Keep."
        while sleep 20
        do
        joinbg
        sleep 1
        enterbattle
        sleep 25
        echo "anti afk"
        xdotool key f
        done

    else
        echo "We are probably in Alterac Valley."
        xdotool keydown Up
        sleep 3
        xdotool keyup Up
        xdotool keydown Right
        sleep 0.21
        xdotool keyup Right
        xdotool keydown Up
        sleep 7.5
        xdotool keyup Up
        echo "waiting for gates to open"
        sleep 60
        xdotool keydown Up
        sleep 30
        xdotool keyup Up

        counter=0

        while [ $counter -lt 10 ]
        do
            xdotool key Down
            sleep 0.1
            xdotool key Down
            sleep 0.1
            xdotool key Down
            sleep 0.1
            xdotool key Up
            sleep 0.1
            xdotool key Up
            sleep 0.1
            xdotool key Up
            sleep 0.3
            xdotool key g
            echo "sneaky afk"
            sleep 30
            ((counter++))
        done
    fi
done
