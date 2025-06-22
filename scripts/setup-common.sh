#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Perform common setup tasks

set -euo pipefail
IFS=$'\n\t'

source ./scripts/_utils.sh

log "==== Starting common setup ===="

log "Updating system packages..."
sudo dnf upgrade -yq

log "Removing unnecessary pre-installed packages..."
sudo dnf remove -yq \
    baobab \
    firefox \
    evince \
    gnome-calculator \
    gnome-calendar \
    gnome-characters \
    gnome-clocks \
    gnome-connections \
    gnome-contacts \
    gnome-font-viewer \
    gnome-logs \
    gnome-maps \
    gnome-text-editor \
    gnome-tour \
    gnome-weather \
    libreoffice-* \
    loupe \
    simple-scan \
    snapshot \
    malcontent-control \
    mediawriter \
    ptyxis \
    yelp

./scripts/install-packages.sh common
./scripts/install-flatpaks.sh common

log "==== Common setup complete ===="
