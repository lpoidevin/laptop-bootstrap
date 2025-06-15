#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# gnome-tweaks.sh - Apply GNOME desktop settings per profile.

set -euo pipefail
IFS=$'\n\t'

source ./scripts/_utils.sh

PROFILE="${1:-}"
log "Applying GNOME settings for profile: $PROFILE"

# Set the GTK theme to a dark variant.
# gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"

# Set the icon theme (modify as needed).
# gsettings set org.gnome.desktop.interface icon-theme "Papirus"

# Configure window button layout (minimize, maximize, close).
# gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'

# Set favorite applications (customize the list as needed).
# gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Nautilus.desktop']"
