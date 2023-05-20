#!/bin/bash
#
# source:
# https://www.knowledgehut.com/blog/devops/private-docker-registry#:~:text=A%20Kubernetes%20docker%20registry%20is,controls%20of%20the%20Kubernetes%20pod.

mkdir -p certs
openssl req -x509 -newkey rsa:4096 -days 365 -nodes -sha256 -keyout certs/tls.key -out certs/tls.crt -subj "/CN=docker-registry" -addext "subjectAltName = DNS:docker-registry"

mkdir auth
docker run --rm --entrypoint htpasswd registry:2.6.2 -Bbn myuser mypasswd > auth/htpasswd

kubectl create secret tls certs-secret --cert=/registry/certs/tls.crt --key=/registry/certs/tls.key
kubectl create secret generic auth-secret --from-file=/registry/auth/htpasswd

cat <<EOM >registry-volume.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
name: docker-repo-pv
spec:
capacity:
storage: 1Gi
accessModes:
- ReadWriteOnce
hostPath:
path: /tmp/repository
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
name: docker-repo-pvc
spec:
accessModes:
- ReadWriteOnce
resources:
requests:
storage: 1Gi
EOM

kubectl create -f registry-volume.yaml


cat <<EOM >docker-registry-pod.yaml
apiVersion: v1
kind: Pod
metadata:
name: docker-registry-pod
labels:
app: registry
spec:
containers:
- name: registry
image: registry:2.6.2
volumeMounts:
- name: repo-vol
mountPath: "/var/lib/registry"
- name: certs-vol
mountPath: "/certs"
readOnly: true
- name: auth-vol
mountPath: "/auth"
readOnly: true
env:
- name: REGISTRY_AUTH
value: "htpasswd"
- name: REGISTRY_AUTH_HTPASSWD_REALM
value: "Registry Realm"
- name: REGISTRY_AUTH_HTPASSWD_PATH
value: "/auth/htpasswd"
- name: REGISTRY_HTTP_TLS_CERTIFICATE
value: "/certs/tls.crt"
- name: REGISTRY_HTTP_TLS_KEY
value: "/certs/tls.key"
volumes:
- name: repo-vol
persistentVolumeClaim:
claimName: docker-repo-pvc
- name: certs-vol
secret:
secretName: certs-secret
- name: auth-vol
secret:
secretName: auth-secret
---
apiVersion: v1
kind: Service
metadata:
name: docker-registry
spec:
selector:
app: registry
ports:
- port: 5000
targetPort: 5000
EOM

kubectl create -f docker-registry-pod.yaml


export REGISTRY_NAME="docker-registry"
export REGISTRY_IP="10.107.59.73"

for x in $(kubectl get nodes -o jsonpath='{ $.items[*].status.addresses[?(@.type=="InternalIP")].address }'); do ssh root@$x "echo '$REGISTRY_IP $REGISTRY_NAME' >> /etc/hosts"; done

for x in $(kubectl get nodes -o jsonpath='{ $.items[*].status.addresses[?(@.type=="InternalIP")].address }'); do ssh root@$x "rm -rf /etc/docker/certs.d/$REGISTRY_NAME:5000;mkdir -p /etc/docker/certs.d/$REGISTRY_NAME:5000"; done

for x in $(kubectl get nodes -o jsonpath='{ $.items[*].status.addresses[?(@.type=="InternalIP")].address }'); do scp /registry/certs/tls.crt  root@$x:/etc/docker/certs.d/$REGISTRY_NAME:5000/ca.crt; done

docker login docker-registry:5000 -u myuser -p mypasswd

kubectl create secret docker-registry reg-cred-secret --docker-server=$REGISTRY_NAME:5000 --docker-username=myuser --docker-password=mypasswd


