#!/bin/bash

set -ex

cd /tmp/
version=3.0.238
url=https://github.com/aliyun/aliyun-cli/releases/download/v${version}/aliyun-cli-linux-${version}-amd64.tgz

curl -LO "${url}"

tar xf aliyun-cli-linux-${version}-amd64.tgz

install aliyun $HOME/bin

rm -rf /tmp/aliyun*

set +ex
