#!/bin/bash

# exit on error
set -e


file="$1"

size=$(echo $(du -sb $file) | cut -f 1 -d ' ')

# Add "i" for influxdb format
size+="i"

echo "file_size,host=\"$(hostname)\",file=\"$file\" size=$size"
