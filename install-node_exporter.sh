#!/bin/bash

ARCH=$(cat /proc/cpuinfo  | \
	grep "model name" | \
	head -n1 | \
	sed "s#.*\t: ##" | \
	cut -d' ' -f1 | \
	sed 's#\([A-Za-z0-9]*\).*#\1#')

case ${ARCH} in
	ARMv5) ARCH="armv5" ;;
	ARMv6) ARCH="armv6" ;;
	ARMv7) ARCH="armv7" ;;
	ARM64) ARCH="arm64" ;;
	*) ARCH="amd64" ;;
esac

echo ${ARCH}

latest_version=$(curl -sL  https://github.com/prometheus/node_exporter/releases/latest | \
	grep "<title>Release" | \
	sed "s#.*<title>Release \([0-9\.]*\).*#\1#")
echo ${latest_version}
url="https://github.com/prometheus/node_exporter/releases/download/v${latest_version}/node_exporter-${latest_version}.linux-${ARCH}.tar.gz"

set -ex

cd /tmp 
curl -sLO ${url}
fn=$(basename ${url})
sudo tar -C /opt -xf ${fn}

svc_name=node_exporter.service
cat <<EOM | sudo tee /lib/systemd/system/${svc_name}
[Unit]
Description=Prometheus Node Exporter

[Service]
Type=simple
ExecStart=/bin/bash -c "/opt/node_exporter-${latest_version}.linux-${ARCH}/node_exporter  --web.listen-address=127.0.0.1:9100"

[Install]
WantedBy=multi-user.target
EOM

sudo systemctl enable ${svc_name}
sudo systemctl restart ${svc_name}

set +ex
