#!/bin/bash

set -ex

cd /tmp || exit 1
# docker-compose
curl -LO "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-linux-x86_64"
mv docker-compose-linux-x86_64 docker-compose
install docker-compose ~/bin/

set +ex

