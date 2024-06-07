#!/bin/bash

VERSION=1.22.4

set -ex
cd /tmp
rm -f /tmp/go${VERSION}.linux-amd64.tar.gz
curl -LO https://go.dev/dl/go${VERSION}.linux-amd64.tar.gz
mkdir -p $HOME/programs
rm -rf $HOME/programs/go
cd $HOME/programs
tar xvf /tmp/go${VERSION}.linux-amd64.tar.gz
echo "go version ${VERSION} installed successfully"
	
set +ex
