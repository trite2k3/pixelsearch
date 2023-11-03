#!/bin/bash

#Time to focus window
sleep 3

function limitedsearch
{
    #Run the binary
    pixelsearch=$(./limitedsearch $1 $2 $3 $ColorDelta $CDelta $4 $5 $EX $EY)

    #Only do stuff if pixel is found
    if [ "$pixelsearch" = "No" ]
        then
            #echo "Pixel not found."
            return 1
        else
        #Split the output into two variables
        IFS=',' read -ra values <<< "$(echo "$pixelsearch" | awk -F',' '{print $1,$2}')"

        #Assign
        varX="${values[0]}"
        varY="${values[1]}"
        return 0
    fi
}

function joinqueue
{
    #Join queue
    echo "Targeting NPC"
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

    #Join bg and accept q
    echo "I would like to go to the battleground."
    xdotool mousemove --sync 2825 449
    xdotool click 1
    sleep 1

    #Join battle
    echo "Pressing Join Battle and joining queue."
    xdotool mousemove --sync 2901 887
    xdotool click 1
}

function enterbattle
{
    #Join bq pop
    echo "Enter battle."
    xdotool mousemove --sync 3645 322
    xdotool click 1
}

function exitbattle
{
    #Exit bq pop
    echo "Exit battle."
    xdotool mousemove --sync 3845 1001
    xdotool click 1
}

function moveAV
{
    #At first entering AV, move to good spot and wait for gates to open.
    echo "Moving to gate."
    xdotool keydown Up
    sleep 2.4
    xdotool keyup Up
    xdotool keydown Right
    sleep 0.26
    xdotool keyup Right
    xdotool keydown d
    sleep 0.5
    xdotool keyup d
    sleep 0.1
    xdotool keydown Up
    sleep 7.5
    xdotool keyup Up
    echo "Waiting for gate."
    sleep 60
    xdotool key Down
    sleep 30
    xdotool key Down
    sleep 10
    echo "Moving out from gate."
    xdotool keydown Up
    sleep 30
    xdotool keyup Up
    sleep 0.1
}

function antiAFK
{
    echo "AntiAFK - Shadowmeld."
    xdotool key Up
    sleep 0.1
    xdotool key Down
    sleep 0.1
    echo "Sleeping for Shadowmeld CD."
    sleep 10
    xdotool key g

}

function antiAFKstormwind
{
    case $afkselect in
        0)
            echo "AntiAFK - Jumping."
            xdotool key space
            sleep 0.1
            xdotool keydown Down
            sleep 0.1
            xdotool keyup Down
            sleep 1
            xdotool keydown Up
            sleep 0.22
            xdotool keyup Up
        ;;
        1)
            echo "AntiAFK - Back and forth."
            xdotool keydown Down
            sleep 0.2
            xdotool keyup Down
            sleep 0.1
            xdotool keydown Up
            sleep 0.115
            xdotool keyup Up
        ;;
        2)
            echo "AntiAFK - Strafing."
            xdotool keydown d
            sleep 0.1
            xdotool keyup d
            sleep 0.1
            xdotool keydown a
            sleep 0.1
            xdotool keyup a
            afkselect=0
        ;;
    esac

    ((afkselect++))
}

function checkcurrentstatus
{
    #Are we in sw keep or AV?
    if limitedsearch 0, 0, 0, 4960, 63
    then
        echo "#We are in Stormwind Keep."
        isinAV=0
    else
        echo "#We are in Alterac Valley"
        isinAV=1
    fi

    #Has the scorescreen popped?
    if limitedsearch 0, 0, 0, 4244, 1001
    then
        echo "#Battle finished."
        battlefinished=1
    else
        echo "#Scorescreen not present."
        battlefinished=0
    fi

    #Are we in queue?
    if limitedsearch 240, 228, 9, 4905, 257
    then
        echo "#In queue."
        queued=1
    else
        echo "#Not in queue."
        queued=0
    fi

    #Has the Enter Battle popped?
    if limitedsearch 120, 3, 0, 3643. 323
    then
        echo "#BG pop!"
        enterbattle=1
    else
        echo "#BG has not popped."
        enterbattle=0
    fi
}

#Global pixelsearch arguments
#Variance allowed in color
ColorDelta=0
CDelta=3
#Just search 1x1 pixels
EX=1
EY=1

#Instance status boolean
isinAV=0
queued=0
battlefinished=0
moveAV=0
afktick=0
afkselect=0

while true
do
    #Get current status
    echo "###"
    checkcurrentstatus

    #Join queue if not queued and not in AV.
    if [ $isinAV = 0 ] && [ $queued = 0 ]
    then
        joinqueue
    elif [ $enterbattle = 1 ]
    then
        enterbattle
    fi

    #If inside AV. Do movement once and exit if scorescreen exist, exit and reset moveonce.
    if [ $isinAV == 1 ]
    then
        if [ $moveAV = 0 ]
        then
            moveAV
            moveAV=1
        elif [ $battlefinished = 1 ]
        then
            exitbattle
            moveAV=0
        fi
        #Shadowmeld AntiAFK
        if [ $afktick -gt 3 ]
        then
            antiAFK
            afktick=0
        fi
    else
        #Bloodrage AntiAFKstormwind
        if [ $afktick -gt 3 ]
        then
            antiAFKstormwind
            afktick=0
        fi
    fi

    ((afktick++))
    sleep 20
done
