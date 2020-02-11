#!/usr/bin/env bash

CURRENT_SINK_INDEX="$(pacmd list-sinks | grep '* index: ' | tr -dc '0-9')"
CARDS="$(pacmd list-sinks | grep "index: " | tr -dc '0-9\n' | sort)"
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
pacmd set-default-sink "$NEXT_SINK_INDEX"

pacmd list-sink-inputs | grep index | cut -c 12- | while read -r input
do
	echo "Moving input $input to sink $NEXT_SINK_INDEX."
	pacmd move-sink-input "$input" "$NEXT_SINK_INDEX"
done
