#!/bin/sh

sudo apt install snapd
sudo snap install microk8s --classic
cat <<EOF 
# This is optional 
sudo usermod -a -G microk8s $USER

echo "alias kubectl='microk8s.kubectl'" >> ~/.bashrc
EOF

