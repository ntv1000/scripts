#!/bin/bash

set -e
set -o xtrace

SCRIPT_DIR=$(dirname "$0")
export RESTIC_REPOSITORY="/run/media/christian/hdd/restic-repo"
export RESTIC_PASSWORD_FILE="$SCRIPT_DIR/password"

restic backup                       \
    --verbose                       \
    --one-file-system               \
    --exclude-caches                \
    --exclude-file="$SCRIPT_DIR/full_machine.exclude"    \
    --tag full_machine              \
    -o local.connections=4          \
    --read-concurrency=4            \
    /
