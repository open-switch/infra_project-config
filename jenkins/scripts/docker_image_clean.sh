#!/bin/bash
   
IMAGE_NAME=$1
[ $# -eq 0 ] && { echo "Usage: $0 IMAGE_TO_CLEAN"; exit 1; }

set +x
echo "==================== rm container and image ====================="

container_name=`docker ps -a | grep $IMAGE_NAME | awk '{print $1}'`   
docker ps -a | grep $IMAGE_NAME | awk '{print $1}'
container_code=$?

docker images | grep $IMAGE_NAME
image_code=$?

if [ $container_code = "0" ]; then
   docker ps -a | grep $IMAGE_NAME | awk '{print $1}' | xargs docker rm -f
   echo " removed container :$container_name"
fi

if [ $image_code = "0" ]; then
   docker rmi $IMAGE_NAME
   echo " removed image :$IMAGE_NAME"
fi

