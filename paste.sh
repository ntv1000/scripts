#!/bin/bash
last_clip=`xclip -o`

echo -n "$1" | xclip -selection clipboard

window_title=`xdotool getwindowfocus getwindowname`

if [[ $window_title = *"Konsole"* ]]; then
	xdotool key ctrl+shift+v
else
	xdotool key ctrl+v
fi

sleep 0.03
echo -n $last_clip | xclip -selection clipboard
