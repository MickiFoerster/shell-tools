#!/bin/bash

set -ex

cd /tmp/
VERSION=v1.13.3
curl -LO https://github.com/hashicorp/terraform/archive/refs/tags/${VERSION}.tar.gz
tar xf ${VERSION}.tar.gz
cd terraform-*
make
make
go build
install terraform $HOME/bin/

rm -rf /tmp/terraform-* /tmp/*${VERSION}*.tar.gz

set +ex
