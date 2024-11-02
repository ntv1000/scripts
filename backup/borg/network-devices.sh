#!/bin/bash

script_dir=$(dirname $0)
echo "Switching to $script_dir"
cd $script_dir

source ../telegraf-inputs/send-event.sh homeserver:8086 telegraf backup_started "Backup started" "Backing up network devices (borg)" "backup"
source ./borg-prune-strats.sh



export BORG_REPO=/mnt/network/diskstation/christian/backups/borg-repo
export BORG_PASSPHRASE="$1"


single_file_backup() {
	echo "Creating backup..."
	borg create                         \
		--lock-wait 43200               \
		--verbose                       \
		--filter AME                    \
		--list                          \
		--stats                         \
		--show-rc                       \
		--compression auto,zstd         \
										\
		::"$2-full-{now}"               \
		$1
	echo "done"
}

archer1_id="archer-c2-192.168.1.4"
archer2_id="archer-c2-192.168.1.5"
netgear_id="netgear-r7000-192.168.1.1"
config="config.bin"

source archer-c2.sh
source netgear-r7000.sh


echo "Backing up router at 192.168.1.4"
archer-c2 "192.168.1.4" $config
if [[ $? == 0 ]]; then
	single_file_backup $config $archer1_id
else
	echo "Backup $archer1_id failed."
fi
rm -f $config
default_prune $archer1_id


echo "Backing up router at 192.168.1.5"
archer-c2 "192.168.1.5" $config
if [[ $? == 0 ]]; then
	single_file_backup $config $archer2_id
else
	echo "Backup $archer2_id failed."
fi
rm -f $config
default_prune $archer2_id


echo "Backing up router at 192.168.1.1"
netgear-r7000 "192.168.1.1" $config
if [[ $? == 0 ]]; then
	single_file_backup $config $netgear_id
else
	echo "Backup $netgear_id failed."
fi
rm -f $config
default_prune $netgear_id
