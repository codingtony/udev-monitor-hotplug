#!/bin/bash

#Adapt this script to your needs.

DEVICES=$(find /sys/class/drm/*/status)

#inspired by /etc/acpd/lid.sh and the function it sources

displaynum=`ls /tmp/.X11-unix/* | sed s#/tmp/.X11-unix/X##`
display=":$displaynum"
export DISPLAY=":$displaynum"

uid=$(ck-list-sessions | awk 'BEGIN { unix_user = ""; } /^Session/ { unix_user = ""; } /unix-user =/ { gsub(/'\''/,"",$3); unix_user = $3; } /x11-display = '\'$display\''/ { print unix_user; exit (0); }')
if [ -n "$uid" ]; then
	user=$(getent passwd $uid | cut -d: -f1)
	userhome=$(getent passwd $user | cut -d: -f6)
	export XAUTHORITY=$userhome/.Xauthority
else
  echo "unable to find an X session"
  exit 1
fi


#this while loop declare the $HDMI1 $VGA1 $LVDS1 and others if they are plugged in
while read l 
do 
  dir=$(dirname $l); 
  status=$(cat $l); 
  dev=$(echo $dir | cut -d\- -f 2-); 
  
  if [ $(expr match  $dev "HDMI") != "0" ]
  then
#REMOVE THE -X- part from HDMI-X-n
    dev=HDMI${dev#HDMI-?-}
  else 
    dev=$(echo $dev | tr -d '-')
  fi

  if [ "connected" == "$status" ]
  then 
    echo $dev "connected"
    declare $dev="yes"; 
  
  fi
done <<< "$DEVICES"


if [ ! -z "$HDMI1" -a ! -z "$VGA1" ]
then
  echo "HDMI1 and VGA1 are plugged in"
  xrandr --output LVDS1 --off
  xrandr --output VGA1 --mode 1920x1080 --noprimary
  xrandr --output HDMI1 --mode 1920x1080 --right-of VGA1 --primary
elif [ ! -z "$HDMI1" -a -z "$VGA1" ]; then
  echo "HDMI1 is plugged in, but not VGA1"
  xrandr --output LVDS1 --off
  xrandr --output VGA1 --off
  xrandr --output HDMI1 --mode 1920x1080 --primary
elif [ -z "$HDMI1" -a ! -z "$VGA1" ]; then
  echo "VGA1 is plugged in, but not HDMI1"
  xrandr --output LVDS1 --off
  xrandr --output HDMI1 --off
  xrandr --output VGA1 --mode 1920x1080 --primary
else
  echo "No external monitors are plugged in"
  xrandr --output LVDS1 --off
  xrandr --output HDMI1 --off
  xrandr --output LVDS1 --mode 1366x768 --primary
fi

