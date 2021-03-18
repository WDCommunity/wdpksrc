#!/bin/sh

# Define APKG_PATH
APKG_PATH="/shares/Volume_1/Nas_Prog"

# Stop and remove the old container
docker stop portainer
docker rm portainer

# Download the latest container build from dockerhub
docker pull portainer/portainer-ce:latest

# Instantiate the new container
docker run -d -p 9000:9000 \
           --name portainer \
           --restart always \
           -v /var/run/docker.sock:/var/run/docker.sock \
           -v $(readlink -f ${APKG_PATH})/portainer:/data \
           portainer/portainer-ce:latest

# Display listing of running containers
docker ps -a
