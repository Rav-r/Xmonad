#!/bin/bash

SINK=$(pactl get-default-sink)

if [ -z "$SINK" ]; then
    echo "<fn=1></fn> Mute"
    exit 1
fi

VOLUME=$(pactl get-sink-volume "$SINK" | awk '{print $5}' | head -n 1 | sed 's/%//')
MUTED=$(pactl get-sink-mute "$SINK" | awk '{print $2}')

if [ "$MUTED" = "yes" ]; then
    ICON=""
elif [ "$VOLUME" -eq 0 ]; then
    ICON=""
elif [ "$VOLUME" -lt 50 ]; then
    ICON=""
else
    ICON=""
fi

# Add an extra space after icon for padding
echo "<fn=1>$ICON</fn>   $VOLUME%"
