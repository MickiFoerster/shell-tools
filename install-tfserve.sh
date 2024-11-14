#!/bin/bash

set -ex

url="https://storage.googleapis.com/tensorflow-serving-apt"
src="stable tensorflow-model-server tensorflow-model-server-universal"
echo "deb ${url} ${src}" | sudo tee /etc/apt/sources.list.d/tensorflow-serving.list
curl https://storage.googleapis.com/tensorflow-serving-apt/tensorflow-serving.release.pub.gpg | sudo apt-key add -
sudo apt update
sudo apt install -y tensorflow-model-server

pip install -q -U tensorflow-serving-api

set +ex
