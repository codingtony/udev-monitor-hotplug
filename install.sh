#!/bin/bash

USER=$(id -nu 1000)
WORKING_DIR="$(dirname "$0")"
SETTINGS_DIR="/home/${USER}/.config/udev_hotplug/"
SETTINGS_FILE="${SETTINGS_DIR}/settings.sh"

if [[ ! -d "${SETTINGS_DIR}" ]]; then
    mkdir -p "${SETTINGS_DIR}"
    chown "${USER}:${USER}" "${SETTINGS_DIR}"
    chmod 644 "${SETTINGS_DIR}" "${SETTINGS_DIR}"
    echo "Created: ${SETTINGS_DIR}"
    echo
    
fi

if [[ ! -f "${SETTINGS_FILE}" ]]; then
    if [[ -f "${WORKING_DIR}/settings.sh" ]]; then
        cp "${WORKING_DIR}/settings.sh" "${SETTINGS_FILE}"
        echo "Copied: ${WORKING_DIR}/settings.sh"
        chown "${USER}:${USER}" "${WORKING_DIR}/settings.sh"
        chmod 644 "${SETTINGS_FILE}" "${WORKING_DIR}/settings.sh"
    fi
    echo
fi

if cp -r "./etc" "/"; then
    echo "'etc' dir copied"
else
    echo "Error while coping 'etc'"
fi

if cp -r "./usr" "/"; then
    echo "'usr' dir copied"
else
    echo "Error while coping 'usr'"
fi

sudo service udev restart
sudo systemctl restart acpid