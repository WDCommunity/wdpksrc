!#/bin/sh
# Stop and remove the old container
docker stop portainer
docker rm portainer

# Download the latest container build from dockerhub
docker pull portainer/portainer

# Instantiate the new container
docker run -d -p 9000:9000 --restart always --name portainer -v /var/run/docker.sock:/var/run/docker.sock -v /mnt/HD/HD_a2/Nas_Prog/docker/portainer:/data portainer/portainer

# Display listing of running containers
docker ps -a
                                  
