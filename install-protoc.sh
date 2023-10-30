#!/bin/bash -ex

VERSION=23.4

cd /tmp || exit 1

curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v${VERSION}/protoc-${VERSION}-linux-x86_64.zip 

t=$HOME/programs/protoc
mkdir -p $t

unzip -o -d $t protoc-${VERSION}-linux-x86_64.zip 

echo "Installed protoc to $t"
echo "Make sure to inclue $t to PATH env variable"
echo "export PATH=\$PATH:$t"

# additional plugins
#go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

curl -LO https://github.com/protocolbuffers/protobuf-go/releases/download/v1.31.0/protoc-gen-go.v1.31.0.linux.amd64.tar.gz
tar xf protoc-gen-go.v1.31.0.linux.amd64.tar.gz
install protoc-gen-go $HOME/bin/

cargo install protobuf-codegen

go get -u google.golang.org/grpc

set +ex
