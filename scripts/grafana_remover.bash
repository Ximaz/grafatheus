#!/bin/bash -e

echo "Reloading daemon and stopping grafana ..."
sudo systemctl stop grafana-server
sudo systemctl daemon-reload

echo "Closing grafana default port : 3000 ..."
ufw deny 3000

echo "Removing the grafana gpg key ..."
curl https://packages.grafana.com/gpg.key | sudo apt-key del -

echo "Removing grafana ..."
sudo apt remove grafana -y
sudo add-apt-repository --remove "deb https://packages.grafana.com/oss/deb stable main"
sudo apt update -y

sudo rm -rf /tmp/grafana