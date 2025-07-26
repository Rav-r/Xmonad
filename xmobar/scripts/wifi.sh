#!/bin/bash
INTERFACE="wlan0"

# Check if interface is up (simplified)
if ! grep -q "$INTERFACE" /proc/net/wireless; then
    echo "󰤭"  # disconnected icon
    exit 0
fi

QUALITY=$(awk -v iface="$INTERFACE" '$1 ~ iface { print int($3 * 100 / 70) }' /proc/net/wireless)

if [ "$QUALITY" -gt 75 ]; then
    ICON="󰤨"  # Full bars
elif [ "$QUALITY" -gt 50 ]; then
    ICON="󰤥"  # 3/4 bars
elif [ "$QUALITY" -gt 25 ]; then
    ICON="󰤢"  # Half bars
elif [ "$QUALITY" -gt 0 ]; then
    ICON="󰤟"  # Low bars
else
    ICON="󰤭"  # Disconnected
fi

echo "$ICON  "
