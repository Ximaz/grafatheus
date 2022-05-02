#!/bin/bash -e

echo "Creating prometheus system user ..."
[[ ! $(getent group prometheus) ]] && groupadd --system prometheus
[[ ! $(getent passwd prometheus) ]] && useradd -s /sbin/nologin --system -g prometheus prometheus

echo "Creating prometheus directories ..."
mkdir -p "/var/lib/prometheus/"
chown -R prometheus:prometheus "/var/lib/prometheus/"
for f in "rules" \
         "rules.d" \
         "files_sd"
do
    mkdir -p "/etc/prometheus/${f}/"
    chown -R prometheus:prometheus "/etc/prometheus/${f}/"
    chmod -R 775 "/etc/prometheus/${f}/"
done

if [[ ! -d "/tmp/prometheus/" ]]; then
    echo "Downloading prometheus ..."
    mkdir -p "/tmp/prometheus/"
    cd "/tmp/prometheus/"
    arch=$(uname -r | cut -d "-" -f 3)
    prometheus_url=$(curl -s "https://api.github.com/repos/prometheus/prometheus/releases/latest" | grep -oP "https://github.com/prometheus/prometheus/releases/download/v.*/prometheus-.*.linux-${arch}.tar.gz")
    curl -L -o archive.tar.gz "${prometheus_url}"

    echo "Extracting prometheus ..."
    tar xf archive.tar.gz
    cd "/tmp/prometheus/$(ls | grep prometheus)/"

    echo "Moving prometheus binary to /usr/local/bin/ ..."
    mv "prometheus" "promtool" "/usr/local/bin/"
    mv "prometheus.yml" "/etc/prometheus/"
    [[ ! -d "/etc/prometheus/consoles/" ]] && mv "consoles/" "/etc/prometheus/"
    [[ ! -d "/etc/prometheus/console_libraries/" ]] && mv "console_libraries/" "/etc/prometheus/"
fi

echo "Crate a prometheus systemd service unit ..."
echo "[Unit]
Description=Prometheus
Documentation=https://prometheus.io/docs/introduction/overview/
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=prometheus
Group=prometheus
ExecReload=/bin/kill -HUP \$MAINPID
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus/ \
  --web.console.templates=/etc/prometheus/consoles/ \
  --web.console.libraries=/etc/prometheus/console_libraries/ \
  --web.listen-address=0.0.0.0:9090 \
  --web.external-url=

SyslogIdentifier=prometheus
Restart=always

[Install]
WantedBy=multi-user.target
" > "/etc/systemd/system/prometheus.service"

echo "Opening prometheus default port : 9090 ..."
ufw allow 9090

echo "Restarting daemon and start prometheus ..."
systemctl daemon-reload
systemctl start prometheus
systemctl enable prometheus
