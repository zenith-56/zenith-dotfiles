#!/usr/bin/env bash
# =============================================================================
# Waybar CPU Animation (Braille Snake)
# =============================================================================
# Description : CPU usage animation for Waybar using Braille characters.
#               Reads /proc/stat to calculate CPU usage and adjusts animation
#               speed dynamically (faster when CPU load is high).
# =============================================================================

frames=("⠁" "⠂" "⠄" "⡀" "⢀" "⠠" "⠐" "⠈")
num_frames=${#frames[@]}
i=0

total_old=0
idle_old=0

while true; do
    read cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
    total_new=$((user+nice+system+idle+iowait+irq+softirq+steal))
    idle_new=$idle

    if [ "$total_old" -ne 0 ]; then
        diff_total=$((total_new - total_old))
        diff_idle=$((idle_new - idle_old))

        if [ "$diff_total" -eq 0 ]; then
            cpu_usage=0
        else
            cpu_usage=$((100 * (diff_total - diff_idle) / diff_total))
        fi
    else
        cpu_usage=0
    fi

    total_old=$total_new
    idle_old=$idle_new

    # Calculate delay based on CPU usage
    if [ "$cpu_usage" -gt 80 ]; then
        delay=0.02
    elif [ "$cpu_usage" -gt 40 ]; then
        delay=0.08
    else
        delay=0.2
    fi

    # Output with tooltip
    echo "<span size='16pt'>${frames[$i]}</span>"

    i=$(( (i + 1) % num_frames ))
    sleep $delay
done
