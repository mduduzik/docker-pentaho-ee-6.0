#! /bin/sh

# Make sure that we're setup with the docker machine correctly
eval $(docker-machine env default)

# Run the pentaho-postgres container first


# Run PDI first
cd ../images/diserver
docker build -t  mduduzik/docker-pentaho-diserver-ee-6.0 .

# Run BA
cd ../images/diserver
docker build -t  mduduzik/docker-pentaho-baserver-ee-6.0 .