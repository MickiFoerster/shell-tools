#!/bin/bash 

set -ex 

cd /tmp
wget https://dl.grafana.com/enterprise/release/grafana-enterprise-10.3.3.linux-amd64.tar.gz
tar -zxvf grafana-enterprise-10.3.3.linux-amd64.tar.gz
mv grafana-v10.3.3 /opt

cat <<EOM | sudo tee /lib/systemd/system/grafana.service

[Unit]
Description=Grafana Server

[Service]
Type=simple
WorkingDirectory=/opt/grafana-v10.3.3/bin/
ExecStart=/opt/grafana-v10.3.3/bin/grafana-server

[Install]
WantedBy=multi-user.target

EOM


set +ex 
