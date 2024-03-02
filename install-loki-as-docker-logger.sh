#!/bin/bash 

sudo docker plugin install grafana/loki-docker-driver:2.9.4 --alias loki --grant-all-permissions

echo "Add the following lines to you docker-compose file"
cat <<EOM 
services:
  myservice:
    image: myservice:1.2.3
    logging:
      driver: loki
      options:
        loki-url: "http://localhost:3100/loki/api/v1/push"
        loki-retries: 2
        loki-max-backoff: 800ms
        loki-timeout: 1s
        keep-file: "true"

EOM

sudo systemctl restart docker.service
