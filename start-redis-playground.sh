#!/bin/bash

svc=redis-server
docker run --name ${svc} \
           -d \
           --rm \
           redis:latest

docker run -it \
           --link ${svc}:redis \
           --rm \
           redis \
           redis-cli -h redis -p 6379

docker stop redis-server
