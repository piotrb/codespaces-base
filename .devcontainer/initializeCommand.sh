#!/bin/sh

set -e

# A command to run locally before anything else. This command is run before "onCreateCommand".

docker -v

# replace docker-compose with a wrapper that enables buildkit
echo "Locating Docker Compose ..."
which docker-compose
echo $PATH

# create docker volume needed by compose
# docker volume create --name=postgres-data
