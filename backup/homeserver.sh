#!/bin/bash

script_dir=$(dirname $0)
echo "Switching to $script_dir"
cd $script_dir

source ../telegraf-inputs/send-event.sh homeserver:8086 telegraf backup_started "Backup started" "Backing up homeserver" "backup"

destination="/mnt/network/diskstation/christian/backups/homeserver"

date=$(date "+%F-%H%M%S")

output_file="homeserver-$date.tar.gz"

echo "Backing up homeserver"

tar -cvpzf $output_file \
	--one-file-system \
	--exclude=$output_file \
	--exclude=/var/cache \
	--exclude=/var/backups \
	/etc /docker /home /var

mv $output_file $destination
