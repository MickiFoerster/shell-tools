#!/bin/bash

set -ex

sudo snap remove microk8s | true
#sudo snap install microk8s --classic --channel=1.25
sudo snap install microk8s --classic 
sudo usermod -a -G microk8s $USER
#newgrp microk8s
sudo chown -f -R $USER ~/.kube
microk8s status --wait-ready
alias k='microk8s kubectl'

microk8s enable dashboard dns registry istio storage

# microk8s stop
echo "Stop microk8s with 'microk8s stop'"
echo "Start microk8s with 'microk8s start'"

set +ex
