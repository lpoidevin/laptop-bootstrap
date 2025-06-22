#!/usr/bin/env bash
# SPDX-License-Identifier: MIT
# setup-dotfiles.sh - Manage dotfiles via bare Git repository.

set -euo pipefail
IFS=$'\n\t'

source ./scripts/_utils.sh

readonly DOTFILES_DIR="${HOME}/.dotfiles"
readonly DOTFILES_ALIAS="config"

define_config_alias() {
    alias "${DOTFILES_ALIAS}"="/usr/bin/git --git-dir=${DOTFILES_DIR} --work-tree=${HOME}"
}

init_dotfiles() {
    log "Initializing dotfiles repository at ${DOTFILES_DIR}"
    git init --bare "${DOTFILES_DIR}"
    define_config_alias
    ${DOTFILES_ALIAS} config status.showUntrackedFiles no
    log "Dotfiles initialized. You can now add and commit tracked files."
}

restore_dotfiles() {
    local repo_url="${1:-}"
    [[ -z "$repo_url" ]] && abort "Missing repo URL for 'restore'"

    log "Cloning dotfiles repo: ${repo_url}"
    git clone --bare "$repo_url" "$DOTFILES_DIR"
    define_config_alias

    log "Checking out dotfiles to home directory"
    if ! ${DOTFILES_ALIAS} checkout; then
        warn "Conflicts found during checkout."
        warn "Consider backing up conflicting files:"
        ${DOTFILES_ALIAS} checkout 2>&1 | grep -E "^\s+" | xargs -I{} mv {} {}.bak
        ${DOTFILES_ALIAS} checkout
    fi

    ${DOTFILES_ALIAS} config status.showUntrackedFiles no
    log "Dotfiles installed and checked out successfully."
}

main() {
    case "${1:-}" in
        init)
            init_dotfiles
            ;;
        restore)
            restore_dotfiles "${2:-}"
            ;;
        *)
            abort "Usage: $0 {init|restore <git-repo-url>}"
            ;;
    esac
}

main "$@"
