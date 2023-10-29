#!/bin/bash

#Run the binary
pixelsearch=$(./search 255 255 255 0 10 0 0 0 0)

#split the output into two variables
IFS=',' read -ra values <<< "$(echo "$pixelsearch" | awk -F',' '{print $1,$2}')"

#Assign
varX="${values[0]}"
varY="${values[1]}"

#move mouse to pos
xdotool mousemove $varX $varY
