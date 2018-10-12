#!/bin/sh

. $(dirname $0)/incl

stop_dvblink()
{
    process=$(pidof $SERVER_NAME)
    if [ -n "$process" ] ; then
        pid=$(echo $process | awk '{ print $1 }')
        if [ -n "$pid" ] ; then
            kill -2 $pid
            waittime=0
            while [ -d /proc/$pid ] ; do
                sleep 1
                waittime=$(expr $waittime + 1)
                if [ $waittime -ge 30 ]; then
                    break
                fi
            done
            kill -9 $pid
        fi
        sleep 3
    fi
}

stop_dvblink


