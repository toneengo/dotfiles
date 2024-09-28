#! /bin/bash

pactl set-source-mute alsa_input.pci-0000_04_00.6.analog-stereo toggle
pactl set-source-mute alsa_input.usb-BLUE_MICROPHONE_Blue_Snowball_797_2020_08_31_39985-00.mono-fallback toggle

if echo $(pactl list sources | grep '^[[:space:]]Mute:' | head -n 2 | tail -n 1) | grep -q "Mute: yes"; then
    pw-play --volume=200 /usr/share/sounds/Oxygen-Window-Minimize.ogg
else
    pw-play --volume=200 /usr/share/sounds/Oxygen-Window-Maximize.ogg
fi
