#!/bin/bash

set -ex

# docker-compose
curl -L "https://github.com/docker/compose/releases/download/v2.16.0/docker-compose-linux-x86_64"  > docker-compose.bin
chmod +x docker-compose.bin
mv docker-compose.bin ~/bin/docker-compose

set +ex

