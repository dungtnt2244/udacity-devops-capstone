#!/usr/bin/env bash

DOCKER_HUB_ID="dungtnt2244"
DOCKER_REPOSITORY="hello-app"
VERSION="2.000"

dockerpath=${DOCKER_HUB_ID}/${DOCKER_REPOSITORY}

echo "Docker ID and Image: $dockerpath"

docker login -u ${DOCKER_HUB_ID}
docker tag ${DOCKER_REPOSITORY}:${VERSION} ${dockerpath}:${VERSION}
docker push ${dockerpath}:${VERSION}