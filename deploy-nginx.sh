#!/bin/bash

cat <<EOM
# Create pod with nginx 
kubectl create deployment my-nginx-deployment \
    --image=nginx \
    --dry-run=client \
    -o yaml > nginx-deployment.yaml
 
# Expose deployment via service
kubectl expose deployment my-nginx-deployment \
        --port=80 \
        --type=NodePort \
        --name=my-nginx-service
EOM
