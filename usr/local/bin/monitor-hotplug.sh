#!/bin/bash

if [[ -n $1 ]]; then
    # debug
    set -x
fi

#Adapt this script to your needs.
DEVICES=(/sys/class/drm/*/status)
DEVICES+=(/tmp/JACK)
DEVICES+=(/proc/acpi/button/lid/*/state)
DEVICES+=(/sys/class/power_supply/AC/online)

#inspired by /etc/acpd/lid.sh and the function it sources
_display=$(find /tmp/.X11-unix/* | sed s#/tmp/.X11-unix/X##)
export DISPLAY=":${_display}.0"

# from https://wiki.archlinux.org/index.php/Acpid#Laptop_Monitor_Power_Off
_xauthority=$(ps -C Xorg -f --no-header | sed -n 's/.*-auth //; s/ -[^ ].*//; p')
export XAUTHORITY=${_xauthority}

#this while loop declare the $HDMI1 $VGA1 $LVDS1 and others if they are plugged in

for DEVPATH in "${DEVICES[@]}"; do
    if [[ ${DEVPATH} == *"JACK"* ]]; then
        DIR=$(basename "${DEVPATH}");
        STATUS=$(cat "${DEVPATH}");
        DEV="${DIR}";
    elif [[ ${DEVPATH} =~ LID|AC ]]; then
        DIR=$(basename "$(dirname "${DEVPATH}")");
        STATUS=$(cat "${DEVPATH}");
        DEV="${DIR}";
    else
        DIR=$(dirname "${DEVPATH}");
        STATUS=$(cat "${DEVPATH}");
        DEV=$(echo "${DIR}" | cut -d- -f 2-);
    fi
    ISHDMI=$(echo "${DEV}" | grep -i 'HDMI')

    if [[ -n "${ISHDMI}" ]]; then
        #REMOVE THE -X- part from HDMI-X-n
        DEV=HDMI${DEV#HDMI-?-}
    else
        DEV=$(echo "${DEV}" | tr -d '-')
    fi

    if [[ "connected" == "${STATUS}" ]]; then
        echo "${DEV} connected"
        declare "${DEV}=yes";
    elif [[ "${STATUS}" == "state:      open" ]]; then
        echo "${DEV} connected"
        declare "${DEV}=yes";
    elif [[ "${STATUS}" == 1 ]]; then
        echo "${DEV} connected"
        declare "${DEV}=yes";
    fi
done

if [[ -n "${HDMI1}" && -n "${VGA1}" ]]; then
    echo "HDMI1 and VGA1 are plugged in"
    # xrandr --output LVDS1 --off
    # xrandr --output VGA1 --mode 1920x1080 --noprimary
    # xrandr --output HDMI1 --mode 1920x1080 --right-of VGA1 --primary
elif [[ -n "${HDMI1}" && -z "${VGA1}" ]]; then
    echo "HDMI1 is plugged in, but not VGA1"
    # xrandr --output LVDS1 --off
    # xrandr --output VGA1 --off
    # xrandr --output HDMI1 --mode 1920x1080 --primary
elif [[ -z "${HDMI1}" && -n "${VGA1}" ]]; then
    echo "VGA1 is plugged in, but not HDMI1"
    # xrandr --output LVDS1 --off
    # xrandr --output HDMI1 --off
    # xrandr --output VGA1 --mode 1920x1080 --primary
else
    echo "No external monitors are plugged in"
    # xrandr --output LVDS1 --off
    # xrandr --output HDMI1 --off
    # xrandr --output LVDS1 --mode 1366x768 --primary
fi
