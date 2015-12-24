#! /bin/sh

# Make sure that we're setup with the docker machine correctly
eval $(docker-machine env default)

# Remove exited containers
docker rm `docker ps --no-trunc -aq`

# Remove tag-less images
docker rmi $(docker images -q -f dangling=true)
