#!/bin/bash

script_dir=$(dirname $0)
echo "Switching to $script_dir"
cd $script_dir

source ../telegraf-inputs/send-event.sh homeserver:8086 telegraf backup_started "Backup started" "Backing up $(hostname) (borg)" "backup"
source ./borg-prune-strats.sh



export BORG_REPO=/mnt/network/diskstation/christian/backups/borg-repo
export BORG_PASSPHRASE="$1"


borg create                         \
    --verbose                       \
	--lock-wait 43200               \
    --filter AME                    \
    --list                          \
    --stats                         \
    --show-rc                       \
    --compression zstd              \
	--one-file-system               \
    --exclude-caches                \
    --exclude-from=full.exclude     \
                                    \
    ::'{hostname}-full-{now}'       \
    /

default_prune '{hostname}-full'
