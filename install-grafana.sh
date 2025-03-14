#!/bin/bash 

version=11.5.2

set -ex 

cd /tmp
wget https://dl.grafana.com/enterprise/release/grafana-enterprise-${version}.linux-amd64.tar.gz
tar -zxvf grafana-enterprise-${version}.linux-amd64.tar.gz
sudo mv grafana-v${version} /opt

cat <<EOM | sudo tee /lib/systemd/system/grafana.service

[Unit]
Description=Grafana Server

[Service]
Type=simple
WorkingDirectory=/opt/grafana-v${version}/bin/
ExecStart=/opt/grafana-v${version}/bin/grafana-server

[Install]
WantedBy=multi-user.target

EOM

sudo systemctl daemon-reload
sudo systemctl start grafana
sudo systemctl enable grafana

set +ex 
