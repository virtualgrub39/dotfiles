#!/usr/bin/env bash

down_msg="<span foreground='#801d1a'>DOWN</span>"

iface=""
for d in /sys/class/net/*; do
    dev=$(basename "$d")
    [ "$dev" = "lo" ] && continue
    [ -d "/sys/class/net/$dev/wireless" ] && continue
    # skip virtual bridges etc? accept most physical/virtual ethernet
    iface=$dev
    break
done

if [ -z "$iface" ]; then
    echo $down_msg
    exit 0
fi


ipaddr=$(ip -4 addr show dev "$iface" | awk '/inet / {sub(/\/.*/,"",$2); print $2; exit}')

up_msg="<span foreground='#1f992f'>"$ipaddr"</span>"

if [ -z "$ipaddr" ]; then
    echo $down_msg
else
    echo "$ipaddr"
fi
