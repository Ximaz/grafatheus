#!/bin/bash -e

echo "Adding the grafana gpg key ..."
curl https://packages.grafana.com/gpg.key | apt-key add -

echo "Installing grafana ..."
add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
apt update -y
apt install grafana -y

echo "Reloading daemon and starting grafana ..."
systemctl daemon-reload
systemctl start grafana-server
systemctl enable grafana-server

echo "Opening grafana default port : 3000  ..."
ufw allow 3000
