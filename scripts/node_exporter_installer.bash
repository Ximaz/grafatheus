#!/bin/bash -e

if [[ ! -f "/tmp/node_exporter/archive.tar.gz" ]]; then
    echo "Downloading node_exporter ..."
    mkdir -p "/tmp/node_exporter/"

    node_exporter_url=$(curl -s "https://api.github.com/repos/prometheus/node_exporter/releases/latest" | grep -oP "https://github.com/prometheus/node_exporter/releases/download/v.*/node_exporter-.*.linux-amd64.tar.gz")
    curl -L -o "/tmp/node_exporter/archive.tar.gz" "${node_exporter_url}"
fi

if [[ ! -d "/tmp/node_exporter/node_exporter*/" ]]; then
    echo "Extracting node_exporter ..."
    tar xf "/tmp/node_exporter/archive.tar.gz" --directory "/tmp/node_exporter/"
fi

if [[ ! -f "/usr/local/bin/" ]]; then
    echo "Copying node_exporter binary to /usr/local/bin/ ..."
    directory=$(find /tmp/node_exporter/node_exporter* | head -n 1)
    cp "${directory}/node_exporter" "/usr/local/bin/"
fi

echo "Creating a node_exporter systemd service unit ..."
echo "[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=default.target
" > "/etc/systemd/system/node_exporter.service"

echo "Opening node_exporter default port : 9100 ..."
ufw allow 9100

echo "Restarting daemon and start node_exporter ..."
systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter

if [[ ! -f "/etc/prometheus/prometheus.yml" ]]; then
    echo "Prometheus is not installed, exiting ..."
    exit 1
fi

echo "  - job_name: 'node_exporter'
    static_configs:
      - targets: ['localhost:9100']" >> "/etc/prometheus/prometheus.yml"

echo "Restarting prometheus ..."
systemctl restart prometheus
