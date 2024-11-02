#!/bin/bash

script_dir=$(dirname $0)
echo "Switching to $script_dir"
cd $script_dir

source ../../telegraf-inputs/send-event.sh homeserver:8086 telegraf backup_started "Backup started" "Backing up my folder (borg)" "backup"
source ./borg-prune-strats.sh



export BORG_REPO=/mnt/network/diskstation/christian/backups/borg-repo
export BORG_PASSPHRASE="$1"



borg create \
	--verbose \
	--progress \
	--lock-wait 43200 \
	--checkpoint-interval 600 \
	--filter AME \
	--list \
	--stats \
	--show-rc \
	--compression zstd \
	--one-file-system \
	--exclude-caches \
	--exclude-from=my-folder.exclude \
\
	'::my-folder-{now}' \
	/mnt/internal-storage/Christian

default_prune 'my-folder'
