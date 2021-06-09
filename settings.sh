#!/bin/bash

declare -a ATENTION_DEVS

function deviceisconnected() {
    export RESULT=false
    declare -a PATHS
    declare -a CONECTED_DEVICES

    PATHS=(/sys/class/input/*/*)
    CONECTED_DEVICES=()
    for path in "${PATHS[@]}"; do
        if [[ "name" == $(basename "${path}") ]]; then
            CONECTED_DEVICES+=("$(cat "${path}")")
        fi
    done

    for dev in "${CONECTED_DEVICES[@]}"; do
        for ATN_DEV in "${ATENTION_DEVS[@]}"; do
            if [[ "${dev}" == "${ATN_DEV}" ]]; then
                echo true
                return 0
            fi
        done
    done
    echo false
    return 0
}

# ------------------------ SETTINGS ------------------------

ATENTION_TO_USB_HID=true
ATENTION_DEVS=(
    "SIGMACHIP USB Keyboard"
    "Microsoft Microsoft® 2.4GHz Transceiver v9.0"
    )

if "${ATENTION_TO_USB_HID}"; then
    export is_usb_dev
    is_usb_dev=$(deviceisconnected)
fi