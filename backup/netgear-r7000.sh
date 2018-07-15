#!/bin/bash

# Tested on 2018-07-13 with Firmware Version "V1.0.9.32_10.2.34"

function netgear-r7000() {
	username="admin"
	password="vfr45tgb"

	# Check if required arguments are given
	if [[ $1 == "" ]] || [[ $2 == "" ]]; then
		echo "USAGE: $0 ADDRESS OUTPUT_FILE"
		return 1;
	fi

	router_address="$1"
	output_file="$2"

	echo -n "Downloading config..."
	wget -O $output_file --timeout=2 --tries=2 --quiet --http-user=$username --http-passwd=$password "http://$router_address/NETGEAR_R7000.cfg"

	# Check if request was successful
	if [[ $? != 0 ]]; then
		echo "ERROR: request failed"
		rm -f $output_file
		return $?;
	fi

	# Check if download was successful
	if grep -q "html" "$output_file"; then
		echo "ERROR: page returned html (most likely there is already an active session)"
		rm -f $output_file
		return 1;
	fi

	echo "Success!"
}
