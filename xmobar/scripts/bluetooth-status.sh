#!/bin/bash

status=$(bluetoothctl show | grep "Powered" | awk '{print $2}')

if [ "$status" = "yes" ]; then
    echo "󰂯"  # Bluetooth ON icon (replace with your favorite Nerd Font icon)
else
    echo "󰂲"  # Bluetooth OFF icon (replace with your favorite Nerd Font icon)
fi
