#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# install.sh - Entrypoint to bootstrap a Linux laptop.

set -euo pipefail
IFS=$'\n\t'

source ./scripts/_utils.sh

# --- Functions ---
usage() {
    echo "Usage: $0 --profile {perso|work}"
    exit 1
}

# --- Argument Parsing ---
if [[ "$#" -ne 2 || "$1" != "--profile" ]]; then
    usage
fi

readonly PROFILE="$2"
readonly VALID_PROFILES=("perso" "work")

# Check if profile is valid
is_valid_profile=false
for valid in "${VALID_PROFILES[@]}"; do
    if [[ "$PROFILE" == "$valid" ]]; then
        is_valid_profile=true
        break
    fi
done

if [[ "$is_valid_profile" != true ]]; then
    valid_list=$(IFS=, ; echo "${VALID_PROFILES[*]}")
    abort "Invalid profile: '$PROFILE'. Valid options: ${valid_list}"
fi

# --- Sudo Authentication ---
log "Requesting sudo access..."
if ! sudo -v; then
    abort "Sudo authentication failed. Cannot continue."
fi

# --- Execute setup steps ---
./scripts/setup-common.sh
./scripts/setup-profile.sh "$PROFILE"

# --- Reboot Recommendation ---
if [[ -f /var/run/reboot-required ]] || \
   [[ "$(rpm -q kernel | wc -l)" -gt 1 ]]; then
    warn "A system reboot is recommended to complete updates."
fi
