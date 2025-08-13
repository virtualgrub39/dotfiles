#!/usr/bin/env bash

PATH1="/sys/devices/platform/coretemp.0/hwmon/hwmon2/temp1_input"

if [ -r "$PATH1" ]; then
    val=$(cat "$PATH1" 2>/dev/null)
    if [ "$val" -gt 1000 ]; then
        deg=$(awk -v v="$val" 'BEGIN{printf "%.0f", v/1000}')
    else
        deg="$val"
    fi
    echo "${deg}°C"
    exit 0
fi

for f in /sys/class/thermal/thermal_zone*/temp; do
    if [ -r "$f" ]; then
        v=$(cat "$f" 2>/dev/null)
        if [ "$v" -gt 1000 ]; then
            echo "$(awk -v x="$v" 'BEGIN{printf "%.0f", x/1000}')°C"
        else
            echo "${v}°C"
        fi
        exit 0
    fi
done

if command -v sensors >/dev/null 2>&1; then
    sensors | awk '/Package id 0|Tctl|temp1/ {for(i=1;i<=NF;i++) if ($i ~ /[0-9]+\.[0-9]°C/) {printf "%s\n", $i; exit}}'
    exit 0
fi

echo "n/a"
