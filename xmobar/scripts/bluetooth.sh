#!/bin/bash
#
# bluetooth-toggle.sh
#
# If Bluetooth is OFF, turn it ON and open blueman-manager.
# If Bluetooth is ON, just open blueman-manager.

status=$(bluetoothctl show | grep "Powered" | awk '{print $2}')

if [ "$status" = "no" ]; then
    bluetoothctl power on
    # Wait a bit to let it actually start
    sleep 1
fi

# Launch blueman-manager
blueman-manager &
