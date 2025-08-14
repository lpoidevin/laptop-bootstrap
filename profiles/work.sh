#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Work environment custom setup

set -euo pipefail
IFS=$'\n\t'

source ./scripts/_utils.sh

# --- Enable required COPR repositories ---
log "Enabling Copr repositories..."
COPRS=(
    "atim/lazygit"
    "atim/starship"
    "cimbali/pympress"
    "wezfurlong/wezterm-nightly"
)

for repo in "${COPRS[@]}"; do
    log "Enabling Copr: $repo"
    sudo dnf copr enable -y "$repo" > /dev/null 2>&1 || warn "Failed to enable: $repo"
done

# --- Enable RPM Fusion repositories (free and nonfree) ---
log "Enabling RPM Fusion repositories..."
if ! rpm -q rpmfusion-free-release > /dev/null 2>&1; then
    sudo dnf install -y \
        https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
else
    log "RPM Fusion free already enabled. Skipping."
fi

if ! rpm -q rpmfusion-nonfree-release > /dev/null 2>&1; then
    sudo dnf install -y \
        https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
else
    log "RPM Fusion nonfree already enabled. Skipping."
fi

# --- Package and Flatpak installation ---
./scripts/install-packages.sh work
./scripts/install-flatpaks.sh work

# --- Directory creation ---
log "Creating development directories..."
mkdir -p "$HOME"/Development/{GitHub,IMTA,local}

# --- Change user shell ---
# if [[ "$(basename "$SHELL")" != "fish" ]]; then
#     log "Changing shell to fish..."
#     sudo chsh "$(whoami)" -s /usr/bin/fish || warn "Could not change shell."
# else
#     log "Shell already set to fish. Skipping."
# fi

# --- Configure printers ---
log "Configuring printers..."
PRINTERS=(
    "IMP-INFO-003|smb://imp-br-01.ad.imta.fr/imp-info-003|HP LaserJet M607.*Postscript"
    "copieurs-avec-badge|smb://imp-br-01.ad.imta.fr/copieurs-avec-badge|Ricoh MP C3004ex.*PS"
)

for entry in "${PRINTERS[@]}"; do
    IFS='|' read -r name uri ppd_pattern <<< "$entry"
    log "Searching for PPD matching: $ppd_pattern"

    matched_ppd=$(lpinfo -m | grep -E "$ppd_pattern" | awk '{print $1}' | head -n 1 || true)

    if [[ -n "$matched_ppd" ]]; then
        log "Using PPD: $matched_ppd for printer: $name"
        if lpadmin -p "$name" -E -v "$uri" -m "$matched_ppd"; then
            log "Successfully added printer: $name"
        else
            warn "Failed to add printer: $name"
        fi
    else
        warn "No matching PPD found for printer: $name (pattern: $ppd_pattern)"
    fi
done
