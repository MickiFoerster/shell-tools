#!/bin/bash

URL=https://nodejs.org/dist/v18.12.1/node-v18.12.1-linux-x64.tar.xz

set -ex

cd /tmp
curl -LO ${URL}
tar -C $HOME/programs -xf $(basename ${URL})
echo PATH=\$PATH:$HOME/programs/$(basename ${URL} .tar.xz)/bin

set +ex
