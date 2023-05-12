#!/bin/bash 

set -ex

cd /tmp
curl -LO https://github.com/gruntwork-io/terragrunt/releases/download/v0.45.11/terragrunt_linux_amd64
mkdir -p ~/bin
install terragrunt_linux_amd64 ~/bin/terragrunt

set +ex
