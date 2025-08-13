#!/usr/bin/env bash
STATEFILE="/tmp/i3blocks_cpu_stat"
FIELD_WIDTH=3

read_cpu() {
    awk '/^cpu /{
        total=0;
        for(i=2;i<=NF;i++) total+= $i;
        print total, $5;
        exit
    }' /proc/stat
}

format_pct() {
    printf "%-*s" "$FIELD_WIDTH" "$1"
}

if [ -r "$STATEFILE" ]; then
    read prev_total prev_idle < "$STATEFILE"
    read total idle < <(read_cpu)
    delta_total=$((total - prev_total))
    delta_idle=$((idle - prev_idle))
    printf "%d %d" "$total" "$idle" > "$STATEFILE"

    if [ "$delta_total" -le 0 ]; then
        pct="n/a"
    else
        pct=$(awk -v dt="$delta_total" -v di="$delta_idle" 'BEGIN{printf "%.0f", (dt-di)/dt*100}')
    fi
else
    read t1 i1 < <(read_cpu)
    sleep 0.2
    read t2 i2 < <(read_cpu)
    delta_total=$((t2 - t1))
    delta_idle=$((i2 - i1))
    printf "%d %d" "$t2" "$i2" > "$STATEFILE"

    if [ "$delta_total" -le 0 ]; then
        pct="n/a"
    else
        pct=$(awk -v dt="$delta_total" -v di="$delta_idle" 'BEGIN{printf "%.0f", (dt-di)/dt*100}')
    fi
fi

num=$(format_pct "$pct%")
echo "${num}"
exit 0
