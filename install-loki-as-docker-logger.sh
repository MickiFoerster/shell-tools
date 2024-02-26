#!/bin/bash 

sudo docker plugin install grafana/loki-docker-driver:2.9.4 --alias loki --grant-all-permissions

sudo cat <<EOM >>/etc/docker/daemon.json
{
    "debug" : true,
    "log-driver": "loki",
    "log-opts": {
        "loki-url": "https://localhost:3100/loki/api/v1/push",
        "loki-batch-size": "400"
    }
}

EOM

sudo systemctl restart docker.service
