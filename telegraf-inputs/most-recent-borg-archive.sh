#!/bin/bash

# exit on error
set -e

repo_path=$1
password=$2
prefix=$3

export BORG_REPO=$repo_path
export BORG_PASSPHRASE=$password


most_recent_archive=$(borg list --lock-wait 600 --prefix $prefix --sort-by timestamp --last 1 --format "{end}")

if [[ $most_recent_archive = "" ]]; then
	echo "most_recent_borg_archive,host=\"$(hostname)\",repository=\"$repo_path\",prefix=\"$prefix\" timestamp=0i,seconds_ago=9223372036854775807i"
	exit 0;
fi

most_recent_timestamp=$(date --date="$most_recent_archive" "+%s")

let seconds_ago=$(date "+%s")-$most_recent_timestamp

# Add "i" for influxdb format
most_recent_timestamp+="i"
seconds_ago+="i"

echo "most_recent_borg_archive,host=\"$(hostname)\",repository=\"$repo_path\",prefix=\"$prefix\" timestamp=$most_recent_timestamp,seconds_ago=$seconds_ago"
