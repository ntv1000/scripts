#!/bin/bash

# exit on error
set -e


directory="$1"

cd $directory

most_recent_file=$(ls -t | head -n1)

if [[ $most_recent_file = "" ]]; then
	echo "most_recent_file,host=\"$(hostname)\",directory=\"$directory\" file=\"[directory empty]\",timestamp=0i,seconds_ago=9223372036854775807i"
	exit 0;
fi

most_recent_timestamp=$(stat --format="%Y" $most_recent_file)
most_recent_timestamp+="i"
let seconds_ago=$(date "+%s")-$(stat --format="%Y" $(ls -t | head -n1))
seconds_ago+="i"

echo "most_recent_file,host=\"$(hostname)\",directory=\"$directory\" file=\"$most_recent_file\",timestamp=$most_recent_timestamp,seconds_ago=$seconds_ago"
