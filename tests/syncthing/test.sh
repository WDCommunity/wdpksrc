#!/bin/bash

source wdpk/$PACKAGE/env

serverReachable() {
	return $(nc -z $TARGET $PORT)
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
		echo "Server not reachable"
		break
		exit 1
	fi
done
echo "Server reachable!"

