#!/bin/bash

VERSION=1.19.5

set -ex
cd /tmp
curl -LO https://go.dev/dl/go${VERSION}.linux-amd64.tar.gz
mkdir -p $HOME/programs
rm -rf $HOME/programs/go.old
cd $HOME/programs
tar xvf /tmp/go${VERSION}.linux-amd64.tar.gz
echo "go version ${VERSION} installed successfully"
	
set +ex
