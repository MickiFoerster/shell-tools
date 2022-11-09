#!/bin/bash 

set -ex

cd /tmp
curl -LO https://github.com/GoogleContainerTools/skaffold/releases/download/v2.0.1/skaffold-linux-amd64
curl -LO https://github.com/GoogleContainerTools/skaffold/releases/download/v2.0.1/skaffold-linux-amd64.sha256
sha256sum --check skaffold-linux-amd64.sha256

mkdir -p ~/bin
install skaffold-linux-amd64 ~/bin/skaffold

set +ex
