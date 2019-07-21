#!/bin/bash

CURRENT_SINK_INDEX=$(pacmd list-sinks | grep "* index: " | tr -dc '0-9')
HIGHEST_SINK_INDEX=$(pacmd list-sinks | grep " index: " | tail -n1 | tr -dc '0-9')

NEXT_SINK_INDEX=$((($CURRENT_SINK_INDEX + 1) % ($HIGHEST_SINK_INDEX + 1)))

pacmd set-default-sink $NEXT_SINK_INDEX

# Inputs have to be moved to the new sink
pacmd list-sink-inputs | grep " index: " | while read input_line
do
	input_index=$(echo "$input_line" | tr -dc '0-9')
	pacmd move-sink-input $input_index $NEXT_SINK_INDEX
done
