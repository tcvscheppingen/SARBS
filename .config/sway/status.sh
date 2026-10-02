#!/bin/sh
# Status line for swaybar. Uses only coreutils, awk and /sys, so it works
# on a default Arch install without i3status or waybar.

while :; do
    battery=""
    for bat in /sys/class/power_supply/BAT*; do
        [ -r "$bat/capacity" ] || continue
        battery="BAT $(cat "$bat/capacity")% $(cat "$bat/status")  |  "
    done

    memory=$(awk '/^MemTotal/ {t = $2} /^MemAvailable/ {a = $2}
        END {printf "%.1fG", (t - a) / 1048576}' /proc/meminfo)

    printf '%sMEM %s  |  %s  |  %s \n' "$battery" "$memory" \
        "$(date +'%a %d %b')" "$(date +'%H:%M:%S')"
    sleep 1
done
