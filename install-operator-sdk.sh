#!/bin/bash

set -e
set -x
cd $(go env GOPATH)
mkdir -p src/github.com/operator-framework
cd       src/github.com/operator-framework
if [[ ! -d operator-sdk ]]; then
    git clone https://github.com/operator-framework/operator-sdk
fi
cd operator-sdk; 
git checkout master
git pull
go mod tidy
make install


