#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# install-packages.sh - Install RPM packages by profile

set -euo pipefail
IFS=$'\n\t'

source ./scripts/_utils.sh

readonly PROFILE="${1:-}"
readonly PACKAGE_FILE="./packages/${PROFILE}.pkg"

[[ -f "$PACKAGE_FILE" ]] || abort "Missing package list: ${PACKAGE_FILE}"

log "Installing packages for profile: $PROFILE"

while IFS= read -r pkg; do
    pkg="${pkg%%#*}"              # Strip comments
    pkg="$(echo "$pkg" | xargs)"  # Trim whitespace
    [[ -z "$pkg" ]] && continue   # Skip empty lines

    log "Installing: $pkg"
    sudo dnf install -yq "$pkg"
done < "$PACKAGE_FILE"

log "All packages for $PROFILE installed."
