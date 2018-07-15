#!/bin/bash

# Tested on 2018-07-13 with Firmware Version "3.0.0 Build 20160713 Rel. 74035(EU)"

function archer-c2() {
	# NOTE: This is how the password is transmitted at login. If you change it you need to update this.
	password="a09392d5d2942a8885e320ccdc8ffa09aef12a7eee268d18c3f61f73cbb409582e70f868be1e0f41af67bcf300886a37c56956dd32c3e0bedd7fe860050f0eacae631eb6fca243a5c70b73fc16cfdf82689238a3b91049d931901bb025417dbdb3cbd2b8f0722c33bbe81e1554fcf6825e28ab55a15ff9268fa23c5c594f4201"
	username="admin"


	# Check if required arguments are given
	if [[ $1 == "" ]] || [[ $2 == "" ]]; then
		echo "USAGE: $0 ADDRESS OUTPUT_FILE"
		return 1;
	fi

	router_address="$1"
	response_file="/tmp/response.txt"
	cookies_file="/tmp/cookies.txt"
	output_file="$2"

	echo "Logging in..."
	wget -O $response_file --timeout=2 --tries=2 --quiet --save-cookies $cookies_file --keep-session-cookies --post-data "operation=login&username=$username&password=$password" "http://$router_address/cgi-bin/luci/;stok=/login?form=login"

	# Check if request was successful
	if [[ $? != 0 ]]; then
		echo "ERROR: request failed"
		cleanup
		return $?;
	fi

	# Check if login was successful
	success=`cat $response_file | jq -r ".success"`
	if [[ $success == "false" ]]; then
		echo "ERROR: failed to login"
		# Parse error information
		error=`cat $response_file | jq -r ".errorcode"`
		echo "$error"
		cleanup
		return 1;
	fi

	# needs to parse 'stok' from json as it is needed for other requests
	stok=`cat $response_file | jq -r ".data.stok"`

	echo -n "Downloading config..."
	wget -O $output_file --timeout=2 --tries=2 --quiet --load-cookies $cookies_file --post-data "operation=backup" "http://$router_address/cgi-bin/luci/;stok=$stok/admin/firmware?form=config"

	# Check if request was successful
	if [[ $? != 0 ]]; then
		echo "ERROR: download failed"
		cleanup
		return $?;
	fi

	echo "Success!"

	echo "Logging out..."
	wget -O $response_file --timeout=2 --tries=2 --quiet --load-cookies $cookies_file --post-data "operation=write" "http://$router_address/cgi-bin/luci/;stok=$stok/admin/system?form=logout"

	# Check if request was successful
	if [[ $? != 0 ]]; then
		echo "ERROR: download failed"
		cleanup
		return $?;
	fi

	# Check if logout was successful
	success=`cat $response_file | jq -r ".success"`
	if [[ $success == "false" ]]; then
		echo "ERROR: failed to login"
		# Parse error information
		error=`cat $response_file | jq -r ".errorcode"`
		echo "$error"
		cleanup
		return 1;
	fi


	cleanup
}

function cleanup() {
	echo "Cleanup..."
	rm -f $response_file $cookies_file
}
