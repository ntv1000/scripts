#!/bin/bash

set -e
set -o xtrace

SCRIPT_DIR=$(dirname "$0")
export RESTIC_PASSWORD_FILE="$SCRIPT_DIR/password"


restic forget                       \
    --repo "/run/media/christian/hdd/restic-repo" \
    --verbose                       \
    --keep-daily    14              \
    --keep-weekly   8               \
    --keep-monthly  unlimited       \
    --host christian-pc             \
    --tag full_machine
restic prune --repo "/run/media/christian/hdd/restic-repo"
restic check --repo "/run/media/christian/hdd/restic-repo"

restic forget                       \
    --repo "/run/media/christian/hdd_external/restic-repo" \
    --prune                         \
    --verbose                       \
    --keep-daily    14              \
    --keep-weekly   8               \
    --keep-monthly  unlimited       \
    --tag my_folder
restic prune --repo "/run/media/christian/hdd_external/restic-repo"
restic check --repo "/run/media/christian/hdd_external/restic-repo"
