#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
READOUT=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0)

BATTERY_PERCENTAGE=$(echo "$READOUT" | grep "perce" | grep -oE '[^ ]+$')
BATTERY_STATE=$(echo "$READOUT" | grep "state" | grep -oE '[^ ]+$')
BATTERY_VAL=$(echo $BATTERY_PERCENTAGE | sed s/%//)
ENV="$DIR/.prev"
read PREV < "$ENV"

if [ $BATTERY_VAL -lt 30 ] && [ $BATTERY_STATE != "charging" ]; then
  echo "Battery warning: $BATTERY_PERCENTAGE remaining"
else
  echo " "
fi


if [ $BATTERY_VAL -lt 28 ] && [ $PREV -gt 27 ]; then
  ICON="$DIR/orange-juice.png"
  notify-send "Battery Status" "Sorry to interupt you but I'm \nrunning low on juice" -u critical -t 0 -i $ICON
fi 

echo $BATTERY_VAL > "$ENV"
