#!/bin/bash -e

echo "Installing prometheus ..."
./scripts/prometheus_installer.bash

echo "Installing node_exporter ..."
./scripts/node_exporter_installer.bash

echo "Installing grafana ..."
./scripts/grafana_installer.bash
