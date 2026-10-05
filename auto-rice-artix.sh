#!/bin/bash
#
# Sway Auto Rice - Gruvbox Theme
# For Artix with dinit. Uses elogind for the login session and turnstile
# for user services (PipeWire and the D-Bus session bus).
# Always check the contents of a script before running it.

set -e

REPO_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
. "$REPO_DIR/common.sh"

if ! grep -qs '^ID=artix' /etc/os-release || ! command -v dinitctl > /dev/null; then
    echo "This script is for Artix with dinit. Use ./auto-rice.sh on other distros." >&2
    exit 1
fi

# Services that are not linked yet, because their service file was missing
MISSING_SERVICES=()

# Start a system service on boot, like `systemctl enable` without --now, so
# the network doesn't drop while the script is running
enable_service() {
    if [ ! -e "/etc/dinit.d/$1" ]; then
        MISSING_SERVICES+=("$1")
    elif [ ! -e "/etc/dinit.d/boot.d/$1" ]; then
        sudo ln -s "/etc/dinit.d/$1" "/etc/dinit.d/boot.d/$1"
    fi
}

# Start a user service when turnstile starts your user dinit on login
enable_user_service() {
    local boot_dir="$HOME/.config/dinit.d/boot.d"
    if [ ! -e "/etc/dinit.d/user/$1" ]; then
        MISSING_SERVICES+=("user/$1")
    elif [ ! -e "$boot_dir/$1" ]; then
        mkdir -p "$boot_dir"
        ln -s "/etc/dinit.d/user/$1" "$boot_dir/$1"
    fi
}

# wmenu is only in Arch's [extra], so enable it after the Artix repos, the
# same way LARBS does
echo "Enabling Arch's [extra] repo for wmenu"
sudo pacman -S --needed artix-archlinux-support
if ! grep -q '^\[extra\]' /etc/pacman.conf; then
    printf '\n[extra]\nInclude = /etc/pacman.d/mirrorlist-arch\n' | sudo tee -a /etc/pacman.conf > /dev/null
fi
sudo pacman-key --populate archlinux

# -Syu rather than -S, because adding a repo needs a database refresh and a
# refresh without an upgrade is a partial upgrade
echo "Installing sway, its utilities, PipeWire, waybar, mako, fonts and dinit services"
sudo pacman -Syu --needed "${ARCH_PACKAGES[@]}" \
    elogind-dinit dbus-dinit networkmanager-dinit bluez-dinit \
    turnstile turnstile-dinit \
    pipewire-dinit pipewire-pulse-dinit wireplumber-dinit

# elogind-dinit enables elogind itself, through the logind service it links
# into boot.d
enable_service dbus
enable_service turnstiled
enable_service bluetoothd
# NetworkManager would fight with connman over the network, so leave a
# working connman setup alone
if [ -e /etc/dinit.d/boot.d/connmand ]; then
    echo "connman manages your network, so NetworkManager is not enabled."
    echo "Disable connmand and enable NetworkManager to use the wifi tray icon."
else
    enable_service NetworkManager
fi

enable_user_service pipewire
enable_user_service pipewire-pulse
enable_user_service wireplumber

# Artix's brightnessctl has no logind support and changes the backlight
# through a udev rule for the video group
sudo usermod -aG video "$USER"

# Create ~/Pictures and the other user folders. grim saves screenshots
# to ~/Pictures.
xdg-user-dirs-update

install_dotfiles

# The portals pick their backend from XDG_CURRENT_DESKTOP, which systemd
# distros set for you
offer_sway_autostart 'if [ -z "$WAYLAND_DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
    export XDG_CURRENT_DESKTOP=sway
    exec sway
fi'

if [ ${#MISSING_SERVICES[@]} -gt 0 ]; then
    echo "These dinit services were not found, so they are not enabled: ${MISSING_SERVICES[*]}" >&2
fi
report_backup
echo "Installed Gruvbox dotfiles successfully"
echo "Reboot so elogind, turnstile, PipeWire, NetworkManager and Bluetooth start"
