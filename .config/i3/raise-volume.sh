#!/usr/bin/env bash
# raise-volume.sh

max=100
step=5

# Get current volume (average of channels)
vol=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | tr -d '%')

# If it's already at or above max, just set to max
if [ "$vol" -ge "$max" ]; then
    pactl set-sink-volume @DEFAULT_SINK@ ${max}%
else
    new=$(( vol + step ))
    if [ "$new" -gt "$max" ]; then
        new=$max
    fi
    pactl set-sink-volume @DEFAULT_SINK@ ${new}%
fi
