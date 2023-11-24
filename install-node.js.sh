#!/bin/bash

URL=https://nodejs.org/dist/v20.10.0/node-v20.10.0-linux-x64.tar.xz

set -ex

cd /tmp
curl -LO ${URL}
tar -C $HOME/programs -xf $(basename ${URL})
echo PATH=\$PATH:$HOME/programs/$(basename ${URL} .tar.xz)/bin

set +ex
