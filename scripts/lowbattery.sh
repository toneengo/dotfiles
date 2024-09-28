#!/bin/bash
battery_level=`acpi -b | grep -P -o '[0-9]+(?=%)' | head -1`
if [ $battery_level -le 20 ]
then
    notify-send "Battery low" "Plug in your computer." -i /usr/share/icons/breeze-dark/status/32/battery-010.svg
fi
