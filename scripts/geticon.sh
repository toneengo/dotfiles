#!/bin/bash

input_string="$1"

#grep 'Icon' $(grep -F $(ps -p $(hyprctl clients -j | jq --arg class "$input_string" '.[] | select(.class == $class) | .pid' | head -n 1) -o comm=
#) -lri --include=\*.desktop /usr/share/applications $HOME/.local/share/applications) | cut -d'=' -f2 | head -n 1

pid=$(hyprctl clients -j | jq --arg class "$input_string" '.[] | select(.class == $class) | .pid' | head -n 1)

if [[ -z "$pid" ]]; then
    exit 1
fi

binary=$(ps -p "$pid" -o comm=)

if [[ -z "$binary" ]]; then
    exit 1
fi

desktop_file=$(grep -F "$binary" -lri --include=\*.desktop /usr/share/applications $HOME/.local/share/applications | head -n 1)

if [[ -z "$desktop_file" ]]; then
    exit 1
fi

icon=$(grep 'Icon' "$desktop_file" | cut -d'=' -f2 | head -n 1)

if [[ -z "$icon" ]]; then
    exit 1
fi

echo "$icon"
