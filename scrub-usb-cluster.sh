#!/bin/bash

script_dir=$(dirname $0)
echo "Switching to $script_dir"
cd $script_dir

source telegraf-inputs/send-event.sh homeserver:8086 telegraf btrfs_scrub "BTRFS scrub started" "Scrubbing /mnt/usb-cluster" "btrfs"

btrfs scrub start /mnt/usb-cluster
