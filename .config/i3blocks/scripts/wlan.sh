#!/usr/bin/env bash

down_msg="<span foreground='#801d1a'>DOWN</span>"

# find wireless interface (iw preferred)
iface=""
if command -v iw >/dev/null 2>&1; then
    iface=$(iw dev 2>/dev/null | awk '/Interface/ {print $2; exit}')
fi

# fallback: first iface with wireless dir
if [ -z "$iface" ]; then
    for d in /sys/class/net/*; do
        dev=$(basename "$d")
        [ -d "/sys/class/net/$dev/wireless" ] && { iface=$dev; break; }
    done
fi

if [ -z "$iface" ]; then
    echo $down_msg
    exit 0
fi

# check operstate
oper=$(cat /sys/class/net/"$iface"/operstate 2>/dev/null || echo DOWN)
if [ "$oper" != "up" ]; then
    echo $down_msg
    exit 0
fi

# get IPv4
ipaddr=$(ip -4 addr show dev "$iface" | awk '/inet / {sub(/\/.*/,"",$2); print $2; exit}')

up_msg="<span foreground='#88d941'>"$ipaddr"</span>"

if [ -z "$ipaddr" ]; then
    echo $down_msg
else
    echo $up_msg
fi
