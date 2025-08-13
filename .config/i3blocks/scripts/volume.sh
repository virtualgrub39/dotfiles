#!/usr/bin/env bash

if command -v pamixer >/dev/null 2>&1; then
    vol=$(pamixer --get-volume 2>/dev/null)
    mute=$(pamixer --get-mute 2>/dev/null)
    if [ "$mute" = "true" ]; then
        echo "MUT"
    elif [ "$vol" -eq 0 ]; then
        echo "X"
    else
        echo "${vol}"
    fi
    exit 0
fi

if command -v amixer >/dev/null 2>&1; then
    out=$(amixer get Master 2>/dev/null)
    pct=$(echo "$out" | awk -F'[][]' '/%/ {print $2; exit}' | tr -d '%')
    mute=$(echo "$out" | awk -F'[][]' '/%/ {print $4; exit}')
    
    if [ -z "$pct" ]; then
        echo "n/a"
    else
        if [ "$mute" = "true" ]; then
            echo "MUT"
        elif [ "$pct" -eq 0 ]; then
            echo "X"
        else
            echo "${vol}"
        fi
    fi
    exit 0
fi

echo "n/a"
