#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# Setup for the selected profile

set -euo pipefail
IFS=$'\n\t'

source ./scripts/_utils.sh

readonly PROFILE="${1:-}"
readonly PROFILE_SCRIPT="./profiles/${PROFILE}.sh"

if [[ -z "$PROFILE" ]]; then
    abort "No profile provided. Usage: $0 <profile>"
fi

if [[ ! -f "$PROFILE_SCRIPT" ]]; then
    abort "Unknown profile: '$PROFILE'. Expected file: ${PROFILE_SCRIPT}"
fi

log "==== Starting setup for profile: $PROFILE ===="
bash "$PROFILE_SCRIPT"
log "==== Profile '$PROFILE' setup complete ===="
