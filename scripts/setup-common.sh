#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Perform common setup tasks

set -euo pipefail
IFS=$'\n\t'

source ./scripts/_utils.sh

log "==== Starting common setup ===="

log "Updating system packages..."
sudo dnf upgrade -yq

log "Removing unnecessary pre-installed packages..."
sudo dnf remove -yq \
    firefox \
    gnome-tour \
    libreoffice-* \
    mediawriter \
    malcontent-control

./scripts/install-packages.sh common
./scripts/install-flatpaks.sh common

log "==== Common setup complete ===="
