#!/bin/bash -e

echo "Removing grafana ..."
./scripts/grafana_remover.bash

echo "Removing node_exporter ..."
./scripts/node_exporter_remover.bash

echo "Removing prometheus ..."
./scripts/prometheus_remover.bash
