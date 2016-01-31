#! /bin/sh

# Make sure that we're setup with the docker machine correctly
eval $(docker-machine env default)

# Run the pentaho-postgres container first
read MY_SSH_KEY < ~/.ssh/id_rsa.pub &&
docker run -d \
  -p 2223:22 \
  -p 5433:5432 \
  --name pentaho-postgresql \
  --volume=/Users/mduduzikeswa/Documents/dev/conxsoft/projects/pentaho/docker-pentaho-postgres9x/data:/srv/pgdata \
  -e PG_USERNAME=pentahoadmin \
  -e PG_PASSWORD=pentahoadmin! \
  -e SSH_PUBLIC_KEY=$MY_SSH_KEY \
  mduduzik/docker-pentaho-postgres9x

docker run -it \
  -p 2232:22 \
  -p 8180:8080 \
  --name pentaho-ba-ee-6 \
  --add-host conx.dev:192.168.99.100 \
  --link pentaho-postgresql:pentaho-postgresql \
  -e PGUSER=pentahoadmin \
  -e PGPASS=pentahoadmin! \
  -e PGHOST=pentaho-postgresql \
  -e PGPORT=5432 \
  -e PGDATABASE=postgres \
  -e SSH_PUBLIC_KEY=$MY_SSH_KEY \
  mduduzik/docker-pentaho-baserver-ee-6.0

docker run -it \
  -p 2233:22 \
  -p 9180:8080 \
  --name pentaho-di-ee-6 \
  --add-host conx.dev:192.168.99.100 \
  --link pentaho-postgresql:pentaho-postgresql \
  -e PGUSER=pentahoadmin \
  -e PGPASS=pentahoadmin! \
  -e PGHOST=pentaho-postgresql \
  -e PGPORT=5432 \
  -e PGDATABASE=postgres \
  -e PDI_SERVER_HOST=localhost \
  -e PDI_SERVER_PORT=8080 \
  -e BIOMEV2_APP=/opt2/pentaho/applications/biome2/etl \
  -e SSH_PUBLIC_KEY=$MY_SSH_KEY \
  mduduzik/docker-pentaho-diserver-ee-6.0