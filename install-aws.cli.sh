#!/bin/bash

sudo yum remove awscli

set -ex


cd /tmp/
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" 
mkdir extract
cd extract/
unzip ../awscliv2.zip 
mkdir -p $HOME/programs
./aws/install  -i $HOME/programs/aws-cli -b $HOME/bin/


set +ex
