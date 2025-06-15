#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# Utility functions for logging and error handling

# ANSI color codes (only if output is a terminal)
if [[ -t 1 ]]; then
    RED='\033[1;31m'
    GREEN='\033[1;32m'
    YELLOW='\033[1;33m'
    RESET='\033[0m'
else
    RED='' GREEN='' YELLOW='' RESET=''
fi

log() {
    echo -e "${GREEN}[+] $*${RESET}"
}

warn() {
    echo -e "${YELLOW}[!] $*${RESET}"
}

abort() {
    echo -e "${RED}[✗] $*${RESET}" >&2
    exit 1
}
