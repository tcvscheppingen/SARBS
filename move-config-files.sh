#!/bin/bash
# Script to move the dotfiles to the config folders without installing any programs.
set -e

REPO_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
. "$REPO_DIR/common.sh"

echo "Moving Sway dotfiles to Home directory"
install_dotfiles

report_backup
echo "Installed Gruvbox dotfiles successfully"
echo "Reload sway with mod + shift + c, or log in to a sway session"
