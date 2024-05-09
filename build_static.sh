#!/bin/bash

image_tag=$(date +%s)
image_tag=chatweb:$image_tag
docker build -t $image_tag -f .\static.Dockerfile .

rm -rf ./dist/html
docker run -v $(pwd):/src --rm --name static_file_server -d --entrypoint sleep $image_tag infinity
docker exec static_file_server sh -c 'mkdir -p /src/dist/html/ && cp -R /usr/share/nginx/html/* /src/dist/html/'

docker rm -f static_file_server
docker rmi $image_tag
