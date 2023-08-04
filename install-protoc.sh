#!/bin/bash -ex

VERSION=23.4

cd /tmp || exit 1

curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v${VERSION}/protoc-${VERSION}-linux-x86_64.zip 

mkdir -p $HOME/bin
mkdir -p $HOME/include

unzip -o -d $HOME protoc-${VERSION}-linux-x86_64.zip 

if [[ "$(which protoc)" != "$HOME/bin/protoc" ]]; then 
    echo "installed version of protoc collides with $(which protoc)"
    exit 1
fi

# additional plugins
#go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

curl -LO https://github.com/protocolbuffers/protobuf-go/releases/download/v1.31.0/protoc-gen-go.v1.31.0.linux.amd64.tar.gz
tar xf protoc-gen-go.v1.31.0.linux.amd64.tar.gz
install protoc-gen-go $HOME/bin/

go get -u google.golang.org/grpc

set +ex
