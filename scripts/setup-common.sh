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
    malcontent-control \
    mediawriter \
    ptyxis \
    rhythmbox \
    simple-scan \
    snapshot \
    totem \
    yelp

log "Removing unnecessary GNOME Shell extensions..."
sudo dnf remove -yq \
    gnome-shell-extension-apps-menu \
    gnome-shell-extension-background-logo \
    gnome-shell-extension-launch-new-instance \
    gnome-shell-extension-places-menu \
    gnome-shell-extension-window-list

./scripts/install-packages.sh common
./scripts/install-flatpaks.sh common

log "==== Common setup complete ===="
