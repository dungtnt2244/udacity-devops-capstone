#!/usr/bin/env bash

CONTAINER_NAME="dungtnt2244/hello-app"
VERSION=1.000
CONTAINER_PORT=80
HOST_PORT=80

# Run flask app
docker run -t --rm -p ${HOST_PORT}:${CONTAINER_PORT} ${CONTAINER_NAME}:${VERSION}