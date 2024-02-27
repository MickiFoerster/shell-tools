#!/bin/bash

set -ex 
cd /tmp/ 

curl -O -L "https://github.com/grafana/loki/releases/download/v2.9.4/loki-linux-amd64.zip"
unzip loki-linux-amd64.zip
chmod a+x loki-linux-amd64

curl -O -L "https://github.com/grafana/loki/releases/download/v2.9.4/promtail-linux-amd64.zip"
unzip promtail-linux-amd64.zip
chmod a+x promtail-linux-amd64

mv promtail-linux-amd64 ~/bin/promtail
mv loki-linux-amd64 ~/bin/loki

set +ex
