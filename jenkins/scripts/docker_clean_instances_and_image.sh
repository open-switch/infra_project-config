#!/bin/bash -e

# Removes any instance of this image, then remove the image

IMAGE=$1

echo "Cleaning all the containers using image $IMAGE"

for name in `docker ps -a -q --filter="image=$IMAGE"`; do \
	   echo "Cleaning the docker container ($name)" ; \
	   docker stop $name >/dev/null ; \
	   docker rm -f $name >/dev/null ; \
 done
if docker images | grep -q $IMAGE ; then
  echo "Removing docker image $IMAGE"
  docker rmi $IMAGE
fi
