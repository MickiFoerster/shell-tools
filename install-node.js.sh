#!/bin/bash

URL=https://nodejs.org/dist/v20.10.0/node-v20.10.0-linux-x64.tar.xz

set -ex

rm -rf /home/micki/programs/node-v*

cd /tmp
curl -LO ${URL}
tar -C $HOME/programs -xf $(basename ${URL})
echo PATH=\$PATH:$HOME/programs/$(basename ${URL} .tar.xz)/bin

rm -f ~/bin/node
ln -sf $HOME/programs/$(basename ${URL} .tar.xz)/bin/node  ~/bin/node
ln -sf $HOME/programs/$(basename ${URL} .tar.xz)/bin/npm   ~/bin/npm

npm install --global yarn

set +ex
