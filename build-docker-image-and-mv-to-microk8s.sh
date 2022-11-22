#!/bin/bash

set -ex

mkdir -p $HOME/docker-build
cd $HOME/docker-build
cat <<EOM >Dockerfile
FROM nginx
EOM

docker build . -t mynginx:local -f Dockerfile

docker save mynginx > myimage.tar
microk8s ctr image import myimage.tar

microk8s ctr image ls | grep mynginx:local

cat <<EOM > deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: mynginx:local
        imagePullPolicy: Never
        ports:
        - containerPort: 80
EOM

microk8s kubectl apply -f deployment.yaml

set +ex
