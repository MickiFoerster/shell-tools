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

cat <<EOM > /etc/promtail/promtail-config.yaml

server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://localhost:8000/loki/api/v1/push

scrape_configs:
- job_name: local_compressed_system_logs
  decompression:
    enabled: true
    initial_delay: 10s
    format: gz
  static_configs:
  - targets:
      - localhost
    labels:
      job: varlogs
      __path__: /var/log/**.gz

- job_name: local_system_logs
  static_configs:
  - targets:
      - localhost
    labels:
      job: varlogs
      __path__: /var/log/*log

- job_name: docker_logs
  pipeline_stages:
    - docker: {}
  static_configs:
    - labels:
        job: docker
        __path__: /var/lib/docker/containers/*/*-json.log

EOM

cat <<EOM > /etc/loki/loki-config.yaml

auth_enabled: false

server:
  http_listen_port: 8000
  grpc_listen_port: 9096

common:
  instance_addr: 127.0.0.1
  path_prefix: /tmp/loki
  storage:
    filesystem:
      chunks_directory: /tmp/loki/chunks
      rules_directory: /tmp/loki/rules
  replication_factor: 1
  ring:
    kvstore:
      store: inmemory

query_range:
  results_cache:
    cache:
      embedded_cache:
        enabled: true
        max_size_mb: 100

schema_config:
  configs:
    - from: 2020-10-24
      store: tsdb
      object_store: filesystem
      schema: v12
      index:
        prefix: index_
        period: 24h

ruler:
  alertmanager_url: http://localhost:9093

EOM

cat <<EOM | sudo tee /lib/systemd/system/promtail.service

[Unit]
Description=Promtail (loki agent)

[Service]
Type=simple
ExecStart=/home/$USER/bin/promtail -config.file=/etc/promtail/promtail-config.yaml

[Install]
WantedBy=multi-user.target

EOM

cat <<EOM | sudo tee /lib/systemd/system/loki.service

[Unit]
Description=Loki (prometheus for log files)

[Service]
Type=simple
ExecStart=/home/$USER/bin/loki -config.file=/etc/loki/loki-config.yaml

[Install]
WantedBy=multi-user.target

EOM

sudo systemctl start promtail.service
sudo systemctl start loki.service

sudo systemctl enable promtail.service
sudo systemctl enable loki.service

set +ex
