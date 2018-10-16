#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
READOUT=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0)

BATTERY_PERCENTAGE=$(echo "$READOUT" | grep "perce" | grep -oE '[^ ]+$')
BATTERY_STATE=$(echo "$READOUT" | grep "state" | grep -oE '[^ ]+$')

if [ $BATTERY_STATE = "charging" ]; then
  ICON="$DIR/battery-charging.png"
  BATTERY_TIME=$(echo "$READOUT" | grep "time to full" | sed s/'time to full:'// | sed 's/^[ \t]*//')
  DESC="$BATTERY_TIME remaining"

elif [ $BATTERY_STATE = "fully-charged" ]; then
  ICON="$DIR/battery-full.png"
  BATTERY_STATE="full"
  BATTERY_TIME=$(echo "$READOUT" | grep "time to full" | sed s/'time to full:'// | sed 's/^[ \t]*//')
  DESC="Unplug to save power"

else
  ICON="$DIR/battery.png"
  BATTERY_TIME=$(echo "$READOUT" | grep "time to empty" | sed s/'time to empty:'// | sed 's/^[ \t]*//')
  DESC="$BATTERY_TIME remaining"
fi

TITLE="Battery $BATTERY_STATE $BATTERY_PERCENTAGE"
notify-send "$TITLE" "$DESC" -i $ICON -u low
