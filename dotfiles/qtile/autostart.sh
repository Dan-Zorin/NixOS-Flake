#!/bin/sh

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

#starting utility applications at boot time
lxsession &
xrandr --output HDMI-0 --mode 1920x1080 -r 59 & 
xrandr --output DP-0  --mode 1920x1080 --primary -r 165 &
feh --bg-fill .config/qtile/assets/nord.jpg
picom --config $HOME/.config/picom/picom.conf &
#run nm-applet &
#run volumeicon &
dunst &
