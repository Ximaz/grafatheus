#!/bin/bash -e

echo "Installing grafana ..."
sudo ./scripts/grafana_installer.bash

echo "Installing prometheus ..."
sudo ./scripts/prometheus_installer.bash

echo "Installing node_exporter ..."
sudo ./scripts/node_exporter_installer.bash