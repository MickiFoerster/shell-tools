#!/bin/bash

set -ex

cd /tmp/

#curl -sSL install.astronomer.io >a.sh
DOWNLOADER="https://raw.githubusercontent.com/astronomer/astro-cli/main/godownloader.sh"
curl -sL -o- ${DOWNLOADER} | bash -s -- -b $HOME/bin

set +ex
