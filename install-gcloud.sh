#!/bin/bash 

set -ex

cd /tmp
curl -LO https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-409.0.0-linux-x86_64.tar.gz
cat <<EOM >google-cloud-cli-409.0.0-linux-x86_64.tar.gz.sha256
190da1c45c48e2647795b4f39116ba7b9882deeeef73e7b8a731dc83a6efe10c  google-cloud-cli-409.0.0-linux-x86_64.tar.gz
EOM

sha256sum --check google-cloud-cli-409.0.0-linux-x86_64.tar.gz.sha256
mkdir -p ~/programs
tar -C ~/programs -xf google-cloud-cli-409.0.0-linux-x86_64.tar.gz

$HOME/programs/google-cloud-sdk/install.sh

set +ex
