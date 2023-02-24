#!/bin/bash

set -ex

cd /tmp
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
cat get_helm.sh | sed "s#/usr/local/bin#$HOME/bin#" | sed "s#runAsRoot cp#cp#" > get_helm.sh.tmp
mv get_helm.sh.tmp get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh

helm repo add stable https://charts.helm.sh/stable

helm search repo redis

set +ex
