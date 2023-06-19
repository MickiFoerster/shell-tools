#!/bin/bash 

set -ex

cd /tmp/
curl -LO https://github.com/hashicorp/terraform/archive/refs/tags/v1.5.0.tar.gz
tar xf v1.5.0.tar.gz 
cd terraform-*
make
make
go build 
install terraform $HOME/bin/

set +ex
