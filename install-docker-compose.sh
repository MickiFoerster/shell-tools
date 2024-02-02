#!/bin/bash

set -ex

version=v2.24.5

cd /tmp/

curl -LO "https://github.com/docker/compose/releases/download/${version}/docker-compose-linux-x86_64"
mv docker-compose-linux-x86_64 docker-compose
install docker-compose $HOME/bin/

set +ex

unset version
