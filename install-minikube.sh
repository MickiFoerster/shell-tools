#!/bin/bash 

set -ex

cd /tmp
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
mkdir -p ~/bin
install minikube-linux-amd64 ~/bin/minikube 

echo 'You can now start minikube:'
echo 'minikube start --driver=virtualbox'

echo 'An alias for kubectl is useful:'
echo 'alias kubectl="minikube kubectl -- "'
set +ex
