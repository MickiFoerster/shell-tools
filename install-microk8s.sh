#!/bin/bash

set -ex

sudo snap install microk8s --classic --channel=1.25
sudo usermod -a -G microk8s $USER
sudo chown -f -R $USER ~/.kube
microk8s status --wait-ready
alias k='microk8s kubectl'
microk8s enable dns storage

# microk8s stop
echo "Stop microk8s with 'microk8s stop'"
echo "Start microk8s with 'microk8s start'"

set +ex
