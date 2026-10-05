#!/bin/bash
#
# Sway Auto Rice - Gruvbox Theme
# For Arch and Arch based distributions (EndeavourOS, CachyOS, ...).
# Always check the contents of a script before running it.

set -e

REPO_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
BACKUP_DIR="$HOME/.config/gruvbox-rice-backup-$(date +%Y%m%d-%H%M%S)"

echo "Installing sway, its default utilities, waybar and the JetBrains Mono Nerd Font"
sudo pacman -S --needed \
    sway swaybg swaylock swayidle wmenu foot waybar \
    grim brightnessctl libpulse \
    ttf-jetbrains-mono-nerd neovim thunar librewolf

# Back up any existing configs this theme replaces
for dir in sway waybar foot swaylock swaynag nvim; do
    if [ -e "$HOME/.config/$dir" ]; then
        mkdir -p "$BACKUP_DIR"
        cp -a "$HOME/.config/$dir" "$BACKUP_DIR/"
    fi
done

# sway reads ~/.sway/config before ~/.config/sway/config, so an old config
# there (for example from the Birmingham theme) would hide this one
if [ -e "$HOME/.sway/config" ]; then
    mkdir -p "$BACKUP_DIR/.sway"
    mv "$HOME/.sway/config" "$BACKUP_DIR/.sway/config"
fi

mkdir -p "$HOME/.config"
cp -a "$REPO_DIR/.config/." "$HOME/.config/"

fc-cache -f

[ -d "$BACKUP_DIR" ] && echo "Your previous configs were backed up to $BACKUP_DIR"
echo "Installed Gruvbox dotfiles successfully"
echo "Reload sway with mod + shift + c, or log in to a sway session"
