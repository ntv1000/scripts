#!/bin/bash

script_dir=$(dirname $0)
echo "Switching to $script_dir"
cd $script_dir

source ../telegraf-inputs/send-event.sh homeserver:8086 telegraf backup_started "Backup started" "Backing up diskstation tv-shows (borg)" "backup"
source ./borg-prune-strats.sh



export BORG_REPO=/mnt/usb-cluster/backups/borg-repo
export BORG_PASSPHRASE="$1"


borg create                         \
    --verbose                       \
    --progress                      \
	--lock-wait 43200               \
	--checkpoint-interval 600       \
    --filter AME                    \
    --list                          \
    --stats                         \
    --show-rc                       \
    --compression zstd              \
	--one-file-system               \
    --exclude-caches                \
                                    \
    ::'diskstation-tv-shows-{now}'  \
    /mnt/network/diskstation/tv-shows

default_prune 'diskstation-tv-shows'

