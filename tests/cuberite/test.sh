#!/bin/bash

source ./env

serverReachable() {
	return $(nc -z $TARGET $PORT)
}

webuiReachable() {
	return $(nc -z $TARGET $WEBGUI_PORT)
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
		#exit 1
	fi
done
echo "Server reachable!"

if ! webuiReachable
then
	echo "Web UI not reachable"
	exit 1
fi
echo "Web UI reachable!"
