#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Install flatpaks from flatpaks/<profile>.flatpak

set -euo pipefail
IFS=$'\n\t'

source ./scripts/_utils.sh

readonly PROFILE="${1:-}"
readonly FLATPAK_FILE="./flatpaks/${PROFILE}.flatpak"

[[ -f "$FLATPAK_FILE" ]] || abort "Missing flatpak list: ${FLATPAK_FILE}"

log "Installing flatpaks for profile: $PROFILE"

while IFS= read -r line; do
    line="${line%%#*}"              # Strip comments
    line="$(echo "$line" | xargs)"  # Trim whitespace
    [[ -z "$line" ]] && continue    # Skip empty lines

    if [[ "$line" == fedora:* ]]; then
        pkg="${line#fedora:}"
        log "Installing from Fedora: $pkg"
        flatpak install -y --noninteractive fedora "$pkg"
    elif [[ "$line" == flathub:* ]]; then
        pkg="${line#flathub:}"
        log "Installing from Flathub: $pkg"
        flatpak install -y --noninteractive flathub "$pkg"
    else
        log "Unknown origin, defaulting to Flathub: $line"
        flatpak install flathub "$line"
    fi
done < "$FLATPAK_FILE"

log "All flatpaks for $PROFILE installed."
