#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# perso.sh - Personal environment setup

set -euo pipefail
IFS=$'\n\t'

source ./scripts/_utils.sh

./scripts/install-packages.sh perso
./scripts/install-flatpaks.sh perso

# log "Creating directories..."
# mkdir -p ~/Projects ~/Downloads/tmp
