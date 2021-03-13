#!/bin/bash

set -e

sudo snap install docker

# docker-compose
curl -L "https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m)"  > docker-compose.bin
chmod +x docker-compose.bin
mv docker-compose.bin ~/bin/docker-compose

# docker-credential-pass
sudo apt install pass
cd /tmp/
curl -LO https://github.com/docker/docker-credential-helpers/releases/download/v0.6.3/docker-credential-pass-v0.6.3-amd64.tar.gz
tar xf docker-credential-pass-v0.6.3-amd64.tar.gz docker-credential-pass
chmod 700 docker-credential-pass
mv docker-credential-pass ~/bin/
rm docker-credential-pass-v0.6.3-amd64.tar.gz
cd -
