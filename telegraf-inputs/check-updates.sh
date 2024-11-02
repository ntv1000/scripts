#!/bin/bash
REBOOT_FILE=/var/run/reboot-required
if [ -f "$REBOOT_FILE" ]; then
        REBOOT_REQUIRED=1
else
        REBOOT_REQUIRED=0
fi

# apt-check writes to stderr. To pipe it into cut stderr needs to be redirected to stdout
UPDATES_AVAILABLE=$(/usr/lib/update-notifier/apt-check 2>&1 | cut -d ";" -f 1)
SECURITY_UPDATES=$(/usr/lib/update-notifier/apt-check 2>&1 | cut -d ";" -f 2)

# Add "i" to indicate integer in influxdb line protocol
REBOOT_REQUIRED+="i"
UPDATES_AVAILABLE+="i"
SECURITY_UPDATES+="i"

LINE="apt_updates updates_available=$UPDATES_AVAILABLE,security_updates=$SECURITY_UPDATES,reboot_required=$REBOOT_REQUIRED"

echo "$LINE"
