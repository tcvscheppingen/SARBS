#!/bin/bash
#
# Sway Auto Rice - Gruvbox Theme
# For Arch and Arch based distributions (EndeavourOS, CachyOS, ...) and Fedora.
# Always check the contents of a script before running it.

set -e

REPO_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
. "$REPO_DIR/common.sh"

# Artix has pacman too, but no systemd, so it has its own script
if grep -qs '^ID=artix' /etc/os-release; then
    echo "This is Artix. Run ./auto-rice-artix.sh instead." >&2
    exit 1
fi

install_arch() {
    sudo pacman -S --needed "${ARCH_PACKAGES[@]}"
}

install_fedora() {
    # LibreWolf is not in the Fedora repos, so add its official repo
    if [ ! -e /etc/yum.repos.d/librewolf.repo ]; then
        curl -fsSL https://repo.librewolf.net/librewolf.repo \
            | sudo tee /etc/yum.repos.d/librewolf.repo > /dev/null
    fi

    # pactl comes from pulseaudio-utils on Fedora
    sudo dnf install \
        sway swaybg swaylock swayidle wmenu foot waybar mako xorg-x11-server-Xwayland \
        pipewire pipewire-pulseaudio wireplumber pulseaudio-utils \
        xdg-desktop-portal-wlr xdg-desktop-portal-gtk lxqt-policykit \
        NetworkManager network-manager-applet bluez blueman \
        grim slurp wl-clipboard xdg-user-dirs brightnessctl playerctl \
        google-noto-sans-fonts google-noto-color-emoji-fonts \
        adwaita-icon-theme adwaita-cursor-theme dconf \
        neovim Thunar librewolf curl tar xz

    # Fedora only packages the plain JetBrains Mono, so get the Nerd Font
    # from the nerd-fonts releases
    if ! fc-list | grep -q "JetBrainsMono Nerd Font"; then
        font_dir="$HOME/.local/share/fonts/JetBrainsMonoNerdFont"
        mkdir -p "$font_dir"
        curl -fL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz \
            | tar -xJ -C "$font_dir"
    fi
}

# Start NetworkManager and Bluetooth on boot. Not with --now, so the
# network doesn't drop while the script is running.
enable_services_systemd() {
    # NetworkManager would fight with systemd-networkd over the network,
    # so leave a working networkd setup alone
    if systemctl is-enabled --quiet systemd-networkd 2> /dev/null; then
        echo "systemd-networkd manages your network, so NetworkManager is not enabled."
        echo "Disable systemd-networkd and enable NetworkManager to use the wifi tray icon."
    else
        sudo systemctl enable NetworkManager
    fi
    sudo systemctl enable bluetooth
}

echo "Installing sway, its utilities, PipeWire, waybar, mako and fonts"
if command -v pacman > /dev/null; then
    install_arch
elif command -v dnf > /dev/null; then
    install_fedora
else
    echo "No pacman or dnf found. Install the packages from the README yourself." >&2
    exit 1
fi
enable_services_systemd

# Create ~/Pictures and the other user folders. grim saves screenshots
# to ~/Pictures.
xdg-user-dirs-update

install_dotfiles

offer_sway_autostart 'if [ -z "$WAYLAND_DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
    exec sway
fi'

report_backup
echo "Installed Gruvbox dotfiles successfully"
echo "Reboot, or log out and log in again, so PipeWire, NetworkManager and Bluetooth start"
