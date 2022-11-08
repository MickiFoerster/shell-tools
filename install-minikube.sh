#!/bin/bash 

set -ex

cd /tmp
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
mkdir -p ~/bin
install minikube-linux-amd64 ~/bin/minikube 

set +ex
