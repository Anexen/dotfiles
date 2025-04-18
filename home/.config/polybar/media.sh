#!/usr/bin/env bash

#   󰓛 󰐊 
#    󰼛 
#     

playerctl --follow status | while read -r status; do
    case "${status}" in
        "Playing") echo "  " ;;
        "Stopped") echo " 󰓛 " ;;
        "Paused") echo " 󰐊 " ;;
    esac
done
