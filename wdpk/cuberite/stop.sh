#!/bin/sh

# stop daemon

/opt/etc/init.d/S62Cuberite stop

[[ $(pidof Cuberite) ]] && kill $(pidof Cuberite)
