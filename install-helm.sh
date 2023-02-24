#!/bin/bash

set -ex

cd /tmp
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
cat get_helm.sh | sed "s#/usr/local/bin#$HOME/bin#" | sed "s#runAsRoot cp#cp#" > get_helm.sh.tmp
mv get_helm.sh.tmp get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh

#helm repo add stable https://charts.helm.sh/stable
helm repo add bitnami https://charts.bitnami.com/bitnami

# add repo for postgres-operator
helm repo add postgres-operator-charts https://opensource.zalando.com/postgres-operator/charts/postgres-operator
# add repo for postgres-operator-ui
helm repo add postgres-operator-ui-charts https://opensource.zalando.com/postgres-operator/charts/postgres-operator-ui

helm repo update

# install the postgres-operator
#helm install postgres-operator postgres-operator-charts/postgres-operator
# install the postgres-operator-ui
#helm install postgres-operator-ui postgres-operator-ui-charts/postgres-operator-ui

helm search repo redis

set +ex
