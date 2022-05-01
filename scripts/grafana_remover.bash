#!/bin/bash -e

echo "Reloading daemon and stopping grafana ..."
systemctl stop grafana-server
systemctl daemon-reload

echo "Closing grafana default port : 3000 ..."
ufw deny 3000

echo "Removing the grafana gpg key ..."
curl https://packages.grafana.com/gpg.key | sudo apt-key del -

echo "Removing grafana ..."
apt remove grafana -y
add-apt-repository --remove "deb https://packages.grafana.com/oss/deb stable main"
apt update -y
