#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Work environment custom setup

set -euo pipefail
IFS=$'\n\t'

source ./scripts/_utils.sh

# --- Enable required COPR repositories ---
log "Enabling Copr repositories..."
COPRS=(
    "che/nerd-fonts"
    "atim/starship"
    "cimbali/pympress"
)

for repo in "${COPRS[@]}"; do
    log "Enabling Copr: $repo"
    sudo dnf copr enable -y "$repo" > /dev/null 2>&1 || warn "Failed to enable: $repo"
done

# --- Package and Flatpak installation ---
./scripts/install-packages.sh work
./scripts/install-flatpaks.sh work

# --- Directory creation ---
log "Creating development directories..."
mkdir -p "$HOME"/Development/{GitHub,IMTA,local} "$HOME"/Nextcloud/IMTA

# --- Change user shell ---
if [[ "$(basename "$SHELL")" != "fish" ]]; then
    log "Changing shell to fish..."
    sudo chsh "$(whoami)" -s /usr/bin/fish || warn "Could not change shell."
else
    log "Shell already set to fish. Skipping."
fi

# --- Optional GNOME tweaks ---
# log "Applying GNOME tweaks for 'work'..."
# ./scripts/gnome-tweaks.sh work
