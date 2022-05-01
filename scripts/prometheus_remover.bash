#!/bin/bash -e

echo "Reloading daemon and start prometheus ..."
systemctl daemon-reload
if [[ -f "/usr/local/bin/prometheus" ]]; then
    systemctl stop prometheus
    systemctl disable prometheus
fi

echo "Closing prometheus default port : 9090 ..."
ufw deny 9090

echo "Removing prometheus system user ..."
if [[ $(getent passwd prometheus) ]]; then userdel prometheus ; fi
if [[ $(getent group prometheus) ]]; then groupdel prometheus ; fi

echo "Removing prometheus directories and files ..."
for p in "/etc/prometheus" \
         "/var/lib/prometheus" \
         "/usr/local/bin/promtool" \
         "/usr/local/bin/prometheus"
do
    rm -rf "${p}"
done

echo "Remove prometheus systemd service unit ..."
rm -f "/etc/systemd/system/prometheus.service"

