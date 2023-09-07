#!/bin/bash -e

echo "Reloading daemon and stopping node_exporter ..."
sudo systemctl daemon-reload
if [[ -f "/usr/local/bin/node_exporter" ]]; then
    sudo systemctl stop node_exporter
    sudo systemctl disable node_exporter
fi

if [[ -f "/etc/prometheus/prometheus.yml" ]]; then
    echo "Removing node_exporter from prometheus yml config ..."
    new_yml=$(cat "/etc/prometheus/prometheus.yml" | tr "\n" "\r" | sed -E "s/  - job_name: 'node_exporter'\r    static_configs:\r      - targets: \['localhost:9100'\]\r//g" | tr "\r" "\n")
    echo "${new_yml}" > "/etc/prometheus/prometheus.yml"
fi

echo "Removing node_exporter binary"
sudo rm -rf "/usr/local/bin/node_exporter"
sudo rm -rf "/tmp/node_exports"

echo "Removing node_exporter systemd service unit ..."
sudo rm -rf "/etc/systemd/system/node_exporter.service"

echo "Closing node_exporter default port : 9100 ..."
sudo ufw deny 9100

if [[ -f "/usr/local/bin/prometheus/" ]]; then
    echo "Restarting prometheus ..."
    sudo systemctl restart prometheus
fi

