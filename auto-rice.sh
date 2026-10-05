#!/bin/bash
#
# Sway Auto Rice - Gruvbox Theme
# For Arch and Arch based distributions (EndeavourOS, CachyOS, ...) and Fedora.
# Always check the contents of a script before running it.

set -e

REPO_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
BACKUP_DIR="$HOME/.config/gruvbox-rice-backup-$(date +%Y%m%d-%H%M%S)"

install_arch() {
    sudo pacman -S --needed \
        sway swaybg swaylock swayidle wmenu foot waybar \
        grim brightnessctl libpulse \
        ttf-jetbrains-mono-nerd neovim thunar librewolf
}

install_fedora() {
    # LibreWolf is not in the Fedora repos, so add its official repo
    if [ ! -e /etc/yum.repos.d/librewolf.repo ]; then
        curl -fsSL https://repo.librewolf.net/librewolf.repo \
            | sudo tee /etc/yum.repos.d/librewolf.repo > /dev/null
    fi

    # pactl comes from pulseaudio-utils on Fedora
    sudo dnf install \
        sway swaybg swaylock swayidle wmenu foot waybar \
        grim brightnessctl pulseaudio-utils \
        neovim thunar librewolf curl tar xz

    # Fedora only packages the plain JetBrains Mono, so get the Nerd Font
    # from the nerd-fonts releases
    if ! fc-list | grep -q "JetBrainsMono Nerd Font"; then
        font_dir="$HOME/.local/share/fonts/JetBrainsMonoNerdFont"
        mkdir -p "$font_dir"
        curl -fL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz \
            | tar -xJ -C "$font_dir"
    fi
}

echo "Installing sway, its default utilities, waybar and the JetBrains Mono Nerd Font"
if command -v pacman > /dev/null; then
    install_arch
elif command -v dnf > /dev/null; then
    install_fedora
else
    echo "No pacman or dnf found. Install the packages from the README yourself." >&2
    exit 1
fi

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
