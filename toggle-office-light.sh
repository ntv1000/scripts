#!/bin/bash
SERVER=$1
TOKEN=$2

hass-cli --server "$SERVER" --token "$TOKEN" service call homeassistant.toggle --arguments entity_id=light.office
