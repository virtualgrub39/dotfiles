#!/usr/bin/env bash

read total used free available <<<$(awk '/MemTotal/ {t=$2} /MemAvailable/ {a=$2} END{used=t-a; print t, used, "0", a}' /proc/meminfo)

hr() {
  v=$1
  # v is in KB
  if [ "$v" -ge $((1024*1024)) ]; then
    awk -v x="$v" 'BEGIN{printf "%.1fG", x/1024/1024}'
  elif [ "$v" -ge 1024 ]; then
    awk -v x="$v" 'BEGIN{printf "%.0fM", x/1024}'
  else
    echo "${v}K"
  fi
}

used_hr=$(hr $used)
available_hr=$(hr $available)
# total_hr=$(hr $total)

threshold_kb=$((1*1024*1024))
if [ "$available" -lt "$threshold_kb" ]; then
    echo "< ${available_hr}"
else
    echo "${used_hr}"
    # echo "${used_hr}/${total_hr}"
fi
