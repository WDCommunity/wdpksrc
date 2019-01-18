#!/bin/bash

source wdpk/$PACKAGE/env
echo "$PACKAGE port is $PORT"

HOSTNAME=$(ssh -G $TARGET | awk '/^hostname / { print $2 }')
echo "Ping $HOSTNAME"

serverReachable() {
	return $(nc -z $HOSTNAME $PORT)
}

count=0
until serverReachable
do
	if [ $count -le 50 ]
       	then
		echo "Waiting for server..."
		sleep 1
		count=$(( $count + 1 ))
	else
		echo "Server $TARGET not reachable"
		exit 1
	fi
done
echo "Server $TARGET reachable!"

