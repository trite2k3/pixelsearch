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

        return 0
    fi
}

function joinbg
{
    #trying to join queue
    echo "targeting npc"
    sleep 0.2
    xdotool key Return
    sleep 0.2
    xdotool key slash
    xdotool key t
    xdotool key a
    xdotool key r
    xdotool key g
    xdotool key e
    xdotool key t
    xdotool key space
    xdotool key T
    xdotool key h
    xdotool key e
    xdotool key l
    xdotool key m
    xdotool key a
    xdotool key n
    xdotool key Return
    xdotool key 0
    sleep 0.1
    xdotool key 0
    sleep 1
    #join bg and accept q
    echo "opening npc chat"
    xdotool mousemove --sync 2825 449
    xdotool click 1
    sleep 1
    #join battle
    echo "pressing join button"
    xdotool mousemove --sync 2901 887
    xdotool click 1
}

function enterbattle
{
    #trying to join bq pop
    xdotool mousemove --sync 3645 322
    xdotool click 1
}

function exitbattle
{
    #trying to join bq pop
    xdotool mousemove --sync 3845 1001
    xdotool click 1
}

#use sleep 3; xdotool getmouselocation to find mousepos
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
    SX=4960
    SY=63
    if limitedsearch "$SRed, $SGreen, $SBlue, $ColorDelta, $CDelta, $SX, $SY, $EX, $EY"
    then
        echo "We are in Stormwind Keep."

        counter=0

        while [ $counter -lt 3 ]
        do
            sleep 2
            joinbg
            enterbattle
            sleep 20
            echo "anti afk"
            xdotool key f
            sleep 13
            ((counter++))
        done

    else
        echo "We are in Alterac Valley."
        xdotool keydown Up
        sleep 3
        xdotool keyup Up
        xdotool keydown Right
        sleep 0.25
        xdotool keyup Right
        xdotool keydown d
        sleep 1
        xdotool keyup d
        sleep 0.1
        xdotool keydown Up
        sleep 7.5
        xdotool keyup Up
        sleep 60
        xdotool keydown Up
        sleep 30
        sleep 0.1

        counter=0

        while [ $counter -lt 5 ]
        do
            xdotool key Down
            sleep 0.1
            xdotool key Up
            sleep 10
            xdotool key g
            echo "sneaky afk"
            sleep 20

            SX=4244
            SY=1001
            if limitedsearch "$SRed, $SGreen, $SBlue, $ColorDelta, $CDelta, $SX, $SY, $EX, $EY"
            then
                echo "exiting battle"
                exitbattle
                continue
            else
                echo "bg not finished"
            fi

            ((counter++))
        done
    fi
done
