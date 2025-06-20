#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# perso.sh - Personal environment setup

set -euo pipefail
IFS=$'\n\t'

source ./scripts/_utils.sh

./scripts/install-packages.sh perso
./scripts/install-flatpaks.sh perso

# log "Creating directories..."
# mkdir -p ~/Projects ~/Downloads/tmp

# log "GNOME Tweaks..."
# ./scripts/gnome-tweaks.sh perso
