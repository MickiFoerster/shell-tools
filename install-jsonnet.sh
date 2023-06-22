#!/bin/bash

set -ex 

cd /tmp
curl -LO https://github.com/google/go-jsonnet/releases/download/v0.20.0/go-jsonnet_0.20.0_Linux_x86_64.tar.gz

tar xf go-jsonnet_0.20.0_Linux_x86_64.tar.gz

mv -v jsonnet* ~/bin/

set +ex

