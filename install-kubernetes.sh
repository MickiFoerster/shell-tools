#!/bin/sh

sudo apt install snapd
sudo snap install microk8s --classic
cat <<EOF 
# This is optional 
sudo usermod -a -G microk8s $USER

echo "alias kubectl='microk8s.kubectl'" >> ~/.bashrc
EOF


# The following installs a docker container that gives you a shell into the
# cluster
kubectl apply -f https://k8smastery.com/shpod.yaml
kubectl attach --namespace=shpod -ti shpod

cat <<EOF
# After you finished the course or if you want to remove shpod use
kubectl delete -f https://k8smasery.com/shpod.yaml
EOF
