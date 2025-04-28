#!/bin/bash

sudo apt update
sudo apt install -y locales openjdk-17-jdk

LANGUAGE="en_US.UTF-8"
LC_ALL="en_US.UTF-8"
LANG="en_US.UTF-8"

sudo locale-gen en_US.UTF-8
sudo update-locale LANG=en_US.UTF-8

if java -version 2>/dev/null; then
    echo "Java JDK successfully installed"
else
    echo "failed to install Java JDK"
fi

# Now install Kafka
cd /tmp
set -e

version=4.0.0
f=kafka_2.13-${version}.tgz
rm -rf /tmp/$f*
wget https://dlcdn.apache.org/kafka/${version}/$f
#wget https://downloads.apache.org/kafka/${version}/$f.sha512
#sha512sum --check $f
dir=$(basename $f .tgz)
tar xf $f && rm -rf $HOME/$dir && mv ${dir} $HOME

if $HOME/$dir/bin/kafka-topics.sh --version; then
    echo "Kafka ${version} successfully installed"
else
    echo "Failed to install Kafka ${version}"
fi

cat <<EOM >>~/.bashrc
PATH=${PATH}:$HOME/$dir/bin
EOM

source ~/.bashrc

id=$(kafka-storage.sh random-uuid)
echo "random uuid: $id"

rm -rf /tmp/kraft-combined-logs
kafka-storage.sh format --standalone -t $id -c $HOME/$dir/config/server.properties
# This will format the directory that is in the log.dirs in the
# config/server.properties file defined

echo "Launch broker itself in daemon mode by"
echo kafka-server-start.sh $HOME/$dir/config/server.properties

set +e
