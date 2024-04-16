#!/bin/bash

VERSION=3.11.4

set -ex
cd /tmp

wget -c https://www.python.org/ftp/python/${VERSION}/Python-${VERSION}.tar.xz

tar -Jxf Python-${VERSION}.tar.xz

cd Python-${VERSION}/

./configure --enable-optimizations

make -j8

sudo make altinstall

python3.11 --version

python3.11 -m pip --version
set +ex
