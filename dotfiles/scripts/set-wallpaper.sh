#!/usr/bin/env bash
# set-wallpaper.sh
set -euo pipefail

WALLPAPER="$1"

awww img "$WALLPAPER" --transition-type wipe --transition-duration 1
wal -i "$WALLPAPER" -n