#!/bin/bash

# Get current volume (take the first volume value in case of multiple channels)
current_volume=$(pactl get-sink-volume @DEFAULT_SINK@ | head -n 1 | awk '{print $5}' | sed 's/%//')

# Check if current volume is already at or above 100%
if [ $current_volume -ge 100 ]; then
    # Set to exactly 100% if we're over
    pactl set-sink-volume @DEFAULT_SINK@ 100%
else
    # Calculate what the new volume would be
    new_volume=$((current_volume + 2))
    
    if [ $new_volume -gt 100 ]; then
        # If the increment would put us over 100%, set to exactly 100%
        pactl set-sink-volume @DEFAULT_SINK@ 100%
    else
        # Otherwise, do the 2% increment
        pactl set-sink-volume @DEFAULT_SINK@ +2%
    fi
fi

# Double-check and force 100% as maximum
current_volume=$(pactl get-sink-volume @DEFAULT_SINK@ | head -n 1 | awk '{print $5}' | sed 's/%//')
if [ $current_volume -gt 100 ]; then
    pactl set-sink-volume @DEFAULT_SINK@ 100%
fi
