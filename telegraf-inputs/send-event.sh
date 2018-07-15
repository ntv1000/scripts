#!/bin/bash

# Check if required arguments are given
if [[ $1 == "" ]] || [[ $2 == "" ]] || [[ $3 == "" ]] || [[ $4 == "" ]] || [[ $5 == "" ]] || [[ $6 == "" ]]; then
	echo "USAGE: $0 ADDRESS:PORT DATABASE EVENT_TYPE TITLE TEXT TAGS"
	echo 'EXAMPLE: ./send-event.sh homeserver:8086 telegraf backup_started "Backup started" "backing up homeserver" "backup"'
	exit 1;
fi

influxdb_address="$1"
database="$2"
hostname=$(hostname)
event_type="$3"

# These also support HTML
title="$4"
text="$5"
tags="$6"

echo "Logging event of type $event_type to db $database at $influxdb_address"
echo "Title: $title"
echo "Text: $text"
echo "Tags: $tags"

curl --silent -i -XPOST "http://$influxdb_address/write?db=$database" --data-binary "events,host=$hostname,type=$event_type title=\"<b>$title</b>\",text=\"$text\",tags=\"$tags\"" > /dev/null
