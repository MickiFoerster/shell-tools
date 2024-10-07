#!/bin/bash

set -ex

cd /tmp/
rm -rf extract awscliv2.zip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
mkdir extract
cd extract/
unzip ../awscliv2.zip
mkdir -p $HOME/programs

if [[ -f $HOME/bin/aws ]]; then
    ./aws/install --update -i $HOME/programs/aws-cli -b $HOME/bin/
else
    ./aws/install -i $HOME/programs/aws-cli -b $HOME/bin/
fi

cd /tmp/ && rm -rf extract awscliv2.zip

set +ex
