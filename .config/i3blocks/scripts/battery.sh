#!/usr/bin/env bash

UEVENT="/sys/class/power_supply/CMB1/uevent"

# Find a valid uevent if the configured path isn't present
if [ ! -r "$UEVENT" ]; then
    for d in /sys/class/power_supply/*; do
        [ -f "$d/uevent" ] || continue
        grep -q '^POWER_SUPPLY_CAPACITY=' "$d/uevent" 2>/dev/null || continue
        UEVENT="$d/uevent"
        break
    done
fi

if [ ! -r "$UEVENT" ]; then
    echo "ERR"
    exit 0
fi

status=$(awk -F= '/^POWER_SUPPLY_STATUS=/ {print $2; exit}' "$UEVENT" 2>/dev/null)
cap=$(awk -F= '/^POWER_SUPPLY_CAPACITY=/ {print $2; exit}' "$UEVENT" 2>/dev/null)

case "$status" in
    Discharging)    st="BAT" ;;
    Charging)       st="CHR" ;;
    "Not charging") st="NCHR" ;;
    Full)           st="FULL" ;;
    *)              st="${status:-UNK}" ;;
esac

if [ -z "$cap" ]; then
    printf "%s n/a\n" "$st"
    exit 0
fi

printf "%s %s%%\n" "$st" "$cap"

exit 0
