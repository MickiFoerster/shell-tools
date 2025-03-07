#!/bin/bash 

version=5.31.0

set -ex
cd /tmp

curl -LO https://downloads.camunda.cloud/release/camunda-modeler/${version}/camunda-modeler-${version}-linux-x64.tar.gz 

cd ~/programs/
tar xvf /tmp/camunda-modeler-${version}-linux-x64.tar.gz 
cd camunda-modeler-${version}-linux-x64/

ln -s $PWD/camunda-modeler ~/bin/

sudo chown root:root chrome-sandbox 

sudo chmod 4755 chrome-sandbox 

ls -l chrome-sandbox 

# Install token simulator 
install_dir=$(pwd)
cd /tmp/
curl -LO https://github.com/camunda/camunda-modeler-token-simulation-plugin/archive/refs/heads/main.zip
cd ${install_dir} && cd resources && cd plugins && unzip /tmp/main.zip

set +ex
