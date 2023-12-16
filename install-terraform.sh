#!/bin/bash 

set -ex

cd /tmp/
VERSION=v1.6.6
curl -LO https://github.com/hashicorp/terraform/archive/refs/tags/${VERSION}.tar.gz
tar xf ${VERSION}.tar.gz 
cd terraform-*
make
make
go build 
install terraform $HOME/bin/

set +ex
