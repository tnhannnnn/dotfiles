#!/bin/bash

AIRPORT="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

SSID=$($AIRPORT -I | awk -F': ' '/ SSID/ {print $2}')
RSSI=$($AIRPORT -I | awk -F': ' '/ agrCtlRSSI/ {print $2}')

if [ -z "$SSID" ]; then
  sketchybar --set wifi label="No WiFi"
else
  sketchybar --set wifi label="$SSID"
fi

