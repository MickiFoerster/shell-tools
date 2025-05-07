#!/bin/bash

set -ex

version=1.46.1

cd /tmp/
curl -LO https://downloads.mongodb.com/compass/mongodb-compass_${version}_amd64.deb
sudo dpkg -i mongodb-compass_${version}_amd64.deb

curl -LO https://downloads.mongodb.com/compass/mongodb-mongosh_2.5.0_amd64.deb
sudo dpkg -i mongodb-mongosh_2.5.0_amd64.deb

curl -LO https://fastdl.mongodb.org/mongocli/mongodb-atlas-cli_1.42.2_linux_x86_64.deb
sudo dpkg -i mongodb-atlas-cli_1.42.2_linux_x86_64.deb

curl -LO https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu2404-x86_64-100.12.0.tgz
tar xf mongodb-database-tools-ubuntu2404-x86_64-100.12.0.tgz
mv mongodb-database-tools-ubuntu2404-x86_64-100.12.0 $HOME/
cat <<EOM >>$HOME/.bashrc
export PATH=$PATH:$HOME/mongodb-database-tools-ubuntu2404-x86_64-100.12.0
EOM

set +ex
