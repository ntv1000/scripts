#!/usr/bin/env bash

CURRENT_SINK_NAME="$(pactl info | grep 'Default Sink' | awk '{print $3}')"
CURRENT_SINK_INDEX="$(pactl list short sinks | grep "$CURRENT_SINK_NAME" | awk '{print $1}')"
CARDS="$(pactl list short sinks | awk '{print $1}' | sort)"
PICKNEXTCARD=1

for card in $CARDS; do
	if [ "$PICKNEXTCARD" == 1 ]; then
		NEXT_SINK_INDEX="$card"
		PICKNEXTCARD=0
	fi
	if [ "$card" == "$CURRENT_SINK_INDEX" ]; then
		PICKNEXTCARD=1
	fi
done

echo "Switching from sink $CURRENT_SINK_INDEX to sink $NEXT_SINK_INDEX."
pactl set-default-sink "$NEXT_SINK_INDEX"

pactl list short sink-inputs | awk '{print $1}' | while read -r input
do
	echo "Moving input $input to sink $NEXT_SINK_INDEX."
	pactl move-sink-input "$input" "$NEXT_SINK_INDEX"
done
