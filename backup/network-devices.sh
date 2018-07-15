#!/bin/bash

script_dir=$(dirname $0)
echo "Switching to $script_dir"
cd $script_dir

source ../telegraf-inputs/send-event.sh homeserver:8086 telegraf backup_started "Backup started" "Backing up network devices" "backup"

destination="/mnt/network/diskstation/christian/backups/network-devices"

date=$(date "+%F-%H%M%S")

archer1="archer-c2-192.168.1.4-$date.bin"
archer2="archer-c2-192.168.1.5-$date.bin"
netgear="netgear-r7000-192.168.1.1-$date.bin"

source archer-c2.sh
source netgear-r7000.sh

echo "Backing up router at 192.168.1.4"
archer-c2 "192.168.1.4" $archer1
if [[ $? == 0 ]]; then
	mv $archer1 $destination/archer-c2-1
fi

echo "Backing up router at 192.168.1.5"
archer-c2 "192.168.1.5" $archer2
if [[ $? == 0 ]]; then
	mv $archer2 $destination/archer-c2-2
fi

echo "Backing up router at 192.168.1.1"
netgear-r7000 "192.168.1.1" $netgear
if [[ $? == 0 ]]; then
	mv $netgear $destination/netgear-r7000
fi

# TODO remove old backups
