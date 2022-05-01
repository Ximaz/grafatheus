#!/bin/bash -e

for p in "curl" "gnupg2" "ufw" "software-properties-common" ; do
    echo "Installing ${p} ..."
    apt install "${p}" -y
done
