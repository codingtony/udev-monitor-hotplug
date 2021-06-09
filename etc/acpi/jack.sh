#!/bin/bash

# EVENT --> $1
#  TYPE --> $2
# STATE --> $3

JACKFILE=/tmp/JACK

case "${3}" in
    plug)
        echo "connected" > "${JACKFILE}"
        logger "${@}"
        ;;
    unplug)
        echo "disconnected" > "${JACKFILE}"
        logger "${@}"
        ;;
esac

if [[ -f "${JACKFILE}" ]]; then
    sudo chmod 666 "${JACKFILE}"
fi