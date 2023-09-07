#!/bin/bash -e

echo "Reloading daemon and start prometheus ..."
sudo systemctl daemon-reload
if [[ -f "/usr/local/bin/prometheus" ]]; then
    sudo systemctl stop prometheus
    sudo systemctl disable prometheus
fi

echo "Closing prometheus default port : 9090 ..."
sudo ufw deny 9090

echo "Removing prometheus system user ..."
if [[ $(getent passwd prometheus) ]]; then userdel prometheus ; fi
if [[ $(getent group prometheus) ]]; then groupdel prometheus ; fi

echo "Removing prometheus directories and files ..."
for p in "/etc/prometheus" \
         "/var/lib/prometheus" \
         "/usr/local/bin/promtool" \
         "/usr/local/bin/prometheus" \
         "/tmp/prometheus"
do
    sudo rm -rf "${p}"
done

echo "Remove prometheus systemd service unit ..."
sudo rm -rf "/etc/systemd/system/prometheus.service"