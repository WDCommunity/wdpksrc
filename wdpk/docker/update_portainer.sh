!#/bin/sh

# Define APKG_PATH
APKG_PATH="/mnt/HD/HD_a2/Nas_Prog/docker"

# Stop and remove the old container
docker stop portainer
docker rm portainer

# Download the latest container build from dockerhub
docker pull portainer/portainer

# Instantiate the new container
docker run -d -p 9000:9000 --restart always --name portainer -v /var/run/docker.sock:/var/run/docker.sock -v $(readlink -f ${APKG_PATH})/portainer:/data portainer/portainer

# Display listing of running containers
docker ps -a
                                  
