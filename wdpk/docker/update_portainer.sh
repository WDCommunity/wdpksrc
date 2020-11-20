!#/bin/sh

# Define APKG_PATH
APKG_PATH="/shares/Volume_1/Nas_Prog"

# Stop and remove the old container
docker stop portainer-ce
docker rm portainer-ce

# Download the latest container build from dockerhub
docker pull portainer/portainer-ce

# Instantiate the new container
docker run -d -p 9000:9000 --restart always --name portainer-ce -v /var/run/docker.sock:/var/run/docker.sock -v $(readlink -f ${APKG_PATH})/portainer:/data portainer/portainer-ce

# Display listing of running containers
docker ps -a
                                  
