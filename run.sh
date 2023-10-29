#!/bin/bash

SRed=255
SGreen=255
SBlue=255
ColorDelta=0
CDelta=10
SX=0
SY=0
EX=0
EY=0

#Run the binary
pixelsearch=$(./search $SRed $SGreen $SBlue $ColorDelta $CDelta $SX $SY $EX $EY)

#split the output into two variables
IFS=',' read -ra values <<< "$(echo "$pixelsearch" | awk -F',' '{print $1,$2}')"

#Assign
varX="${values[0]}"
varY="${values[1]}"

#move mouse to pos
xdotool mousemove $varX $varY
