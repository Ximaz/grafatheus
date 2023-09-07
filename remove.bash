#!/bin/bash -e

echo "Removing grafana ..."
sudo ./scripts/grafana_remover.bash

echo "Removing node_exporter ..."
sudo ./scripts/node_exporter_remover.bash

echo "Removing prometheus ..."
sudo ./scripts/prometheus_remover.bash
