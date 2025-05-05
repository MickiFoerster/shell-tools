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

export PATH=${PATH}:$HOME/$dir/bin

id=$(kafka-storage.sh random-uuid)
echo "random uuid: $id"

rm -rf /tmp/kraft-combined-logs
kafka-storage.sh format --standalone -t $id -c $HOME/$dir/config/server.properties
# This will format the directory that is in the log.dirs in the
# config/server.properties file defined

cat <<EOM >/lib/systemd/system/kafka.service
[Unit]
Description=Kafka Broker

[Service]
Type=simple
ExecStart=$HOME/$dir//bin/kafka-server-start.sh $HOME/$dir//config/server.properties

[Install]
WantedBy=multi-user.target
EOM

sudo systemctl daemon-reload
sudo systemctl start kafka.service
sudo systemctl enable kafka.service

echo "Launch broker itself in daemon mode by"
echo kafka-server-start.sh $HOME/$dir/config/server.properties

set +e

echo "################################################################################"
echo "Example for producing messages"
cat <<EOM
dev@my-medium-instance-4gb:~$ kafka-console-producer.sh --bootstrap-server localhost:9092 --topic my-topic-name
>Hello World!
>This is a test.
>^Cdev@my-medium-instance-4gb:~$ kafka-topics.sh --list
--bootstrap-server must be specified
java.lang.IllegalArgumentException: --bootstrap-server must be specified
	at org.apache.kafka.tools.TopicCommand$TopicCommandOptions.checkRequiredArgs(TopicCommand.java:975)
	at org.apache.kafka.tools.TopicCommand$TopicCommandOptions.checkArgs(TopicCommand.java:968)
	at org.apache.kafka.tools.TopicCommand$TopicCommandOptions.<init>(TopicCommand.java:828)
	at org.apache.kafka.tools.TopicCommand.execute(TopicCommand.java:100)
	at org.apache.kafka.tools.TopicCommand.mainNoExit(TopicCommand.java:90)
	at org.apache.kafka.tools.TopicCommand.main(TopicCommand.java:85)

dev@my-medium-instance-4gb:~$ kafka-topics.sh --bootstrap-server localhost:9092 --list
asdf
my-topic-name
dev@my-medium-instance-4gb:~$ kafka-console-producer.sh --bootstrap-server localhost:9092 --topic my-topic-name
>This is the second test. How are you?
>Test
>Huhu

EOM

echo "################################################################################"
echo "Example for consuming messages"
cat <<EOM
dev@my-medium-instance-4gb:~$ kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic my-topic-name 
^CProcessed a total of 0 messages
dev@my-medium-instance-4gb:~$ kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic my-topic-name --from-beginning 
Hello World!
This is a test.
^CProcessed a total of 2 messages
dev@my-medium-instance-4gb:~$ kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic my-topic-name --from-beginning 
Hello World!
This is a test.
This is the second test. How are you?
Test
^CProcessed a total of 4 messages

dev@my-medium-instance-4gb:~$ kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic my-topic-name --from-beginning  --property print.timestamp=true --property print.key=true --property print.value=true --property print.partition=true 
CreateTime:1745911428936	Partition:0	null	Hello World!
CreateTime:1745911434085	Partition:0	null	This is a test.
CreateTime:1745912051428	Partition:0	null	This is the second test. How are you?
CreateTime:1745913564873	Partition:0	null	Test
CreateTime:1745913689960	Partition:0	null	Huhu



EOM
echo "################################################################################"
