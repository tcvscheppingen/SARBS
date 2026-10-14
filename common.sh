# Steps shared by auto-rice.sh, auto-rice-artix.sh and move-config-files.sh.
# Those scripts set REPO_DIR and source this file; it is not run on its own.

# The dotfiles, user services and login snippet go to the user who runs the
# script, so it must be the user who will use sway. The scripts use sudo for
# the parts that need root.
if [ "$(id -u)" -eq 0 ]; then
    echo "Run this as the user who will use sway, not as root. It uses sudo where it needs root." >&2
    exit 1
fi

BACKUP_DIR="$HOME/.config/gruvbox-rice-backup-$(date +%Y%m%d-%H%M%S)"

# Packages for Arch and Artix. Artix has all of them in its own repos except
# wmenu, which comes from Arch's [extra]. pipewire-jack answers pacman's
# question which JACK to use; its default, jack2, would sit next to PipeWire
# instead of using it.
ARCH_PACKAGES=(
    sway swaybg swaylock swayidle wmenu foot waybar mako xorg-xwayland
    pipewire pipewire-pulse pipewire-jack wireplumber libpulse
    xdg-desktop-portal-wlr xdg-desktop-portal-gtk lxqt-policykit
    networkmanager network-manager-applet bluez bluez-utils blueman
    grim slurp wl-clipboard xdg-user-dirs brightnessctl playerctl jq libnotify
    wf-recorder ffmpeg
    ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji
    adwaita-icon-theme adwaita-cursors dconf
    neovim thunar librewolf
)

# Copy a file or folder into the backup folder
backup() {
    mkdir -p "$BACKUP_DIR"
    cp -a "$1" "$BACKUP_DIR/"
}

# Back up the configs this theme replaces, then copy the dotfiles into ~/.config
install_dotfiles() {
    for dir in sway waybar mako foot swaylock swaynag nvim; do
        if [ -e "$HOME/.config/$dir" ]; then
            backup "$HOME/.config/$dir"
        fi
    done

    # sway reads ~/.sway/config before ~/.config/sway/config, so an old config
    # there would hide this one
    if [ -e "$HOME/.sway/config" ]; then
        mkdir -p "$BACKUP_DIR/.sway"
        mv "$HOME/.sway/config" "$BACKUP_DIR/.sway/config"
    fi

    mkdir -p "$HOME/.config"
    cp -a "$REPO_DIR/.config/." "$HOME/.config/"

    for script in "$REPO_DIR"/.local/bin/*; do
        if [ -e "$HOME/.local/bin/$(basename "$script")" ]; then
            backup "$HOME/.local/bin/$(basename "$script")"
        fi
    done
    mkdir -p "$HOME/.local/bin"
    cp -a "$REPO_DIR/.local/bin/." "$HOME/.local/bin/"

    fc-cache -f
}

# Print the login profile of the user's shell, or nothing for shells other
# than bash and zsh
login_profile() {
    case "$(basename "${SHELL:-}")" in
        bash)
            # bash reads only the first of these that exists, so use that one
            for file in "$HOME/.bash_profile" "$HOME/.bash_login" "$HOME/.profile"; do
                if [ -e "$file" ]; then
                    echo "$file"
                    return
                fi
            done
            echo "$HOME/.bash_profile"
            ;;
        zsh)
            echo "${ZDOTDIR:-$HOME}/.zprofile"
            ;;
    esac
}

# Start sway on TTY1 from the login profile, as the Arch Wiki recommends.
# $1 is the snippet that starts sway. Sway then starts waybar, mako and the
# rest itself.
add_tty_login() {
    local snippet="$1"
    local profile
    profile="$(login_profile)"

    if [ -z "$profile" ]; then
        echo "Your login shell ($(basename "${SHELL:-}")) is not bash or zsh. See the README to start sway on login."
        return
    fi
    if grep -qsE "exec (dbus-run-session )?sway" "$profile"; then
        echo "$profile already starts sway"
        return
    fi
    [ -e "$profile" ] && backup "$profile"
    printf '\n# Start sway on TTY1 (added by the Gruvbox sway rice)\n%s\n' "$snippet" >> "$profile"
    echo "Added sway to $profile"
}

# Link a dinit service into boot.d (Artix), or enable a systemd unit
enable_boot_service() {
    if command -v dinitctl > /dev/null; then
        [ -e "/etc/dinit.d/boot.d/$1" ] || sudo ln -s "/etc/dinit.d/$1" "/etc/dinit.d/boot.d/$1"
    else
        sudo systemctl enable "$1"
    fi
}

# The display manager that already starts on boot, if any
current_display_manager() {
    local dm
    if command -v dinitctl > /dev/null; then
        for dm in lightdm sddm gdm lxdm ly greetd; do
            if [ -e "/etc/dinit.d/boot.d/$dm" ]; then
                echo "$dm"
                return
            fi
        done
    elif [ -L /etc/systemd/system/display-manager.service ]; then
        basename "$(readlink /etc/systemd/system/display-manager.service)" .service
    fi
}

# LightDM with a minimal gruvbox greeter: the wallpaper, a login box in dark
# Adwaita and a panel with only the host name, clock and power menu. The sway
# package has the session file (/usr/share/wayland-sessions/sway.desktop),
# which also sets XDG_CURRENT_DESKTOP=sway for the portals.
add_display_manager() {
    local current
    echo "Installing LightDM with a minimal gruvbox greeter"
    if grep -qs '^ID=artix' /etc/os-release; then
        sudo pacman -S --needed --noconfirm lightdm lightdm-gtk-greeter lightdm-dinit gnome-themes-extra
    elif command -v pacman > /dev/null; then
        sudo pacman -S --needed --noconfirm lightdm lightdm-gtk-greeter gnome-themes-extra
    else
        sudo dnf install lightdm lightdm-gtk gnome-themes-extra
    fi

    # The greeter runs as the lightdm user, which can't read your home folder
    sudo install -Dm644 "$REPO_DIR/.config/sway/wallpaper.jpg" /usr/share/backgrounds/gruvbox-rice/wallpaper.jpg
    if [ -e /etc/lightdm/lightdm-gtk-greeter.conf ]; then
        backup /etc/lightdm/lightdm-gtk-greeter.conf
    fi
    sudo tee /etc/lightdm/lightdm-gtk-greeter.conf > /dev/null << 'EOF'
# Minimal gruvbox greeter (Gruvbox sway rice)
[greeter]
background = /usr/share/backgrounds/gruvbox-rice/wallpaper.jpg
user-background = false
transition-type = none
theme-name = Adwaita-dark
icon-theme-name = Adwaita
cursor-theme-name = Adwaita
font-name = JetBrainsMono Nerd Font 11
hide-user-image = true
indicators = ~host;~spacer;~clock;~spacer;~power
clock-format = %a %d %b  %H:%M
EOF
    sudo mkdir -p /etc/lightdm/lightdm.conf.d
    printf '# Gruvbox sway rice\n[Seat:*]\ngreeter-session=lightdm-gtk-greeter\nuser-session=sway\n' \
        | sudo tee /etc/lightdm/lightdm.conf.d/50-gruvbox-rice.conf > /dev/null

    # Two display managers would fight over the screen
    current="$(current_display_manager)"
    if [ -n "$current" ] && [ "$current" != lightdm ]; then
        echo "$current already starts on boot, so LightDM is not enabled. Disable $current and enable lightdm to use it."
    else
        enable_boot_service lightdm
        echo "LightDM starts on boot; choose the Sway session there"
    fi
}

# How sway starts: RICE_LOGIN=tty|dm|none skips the question. $1 is the
# snippet for the login profile.
offer_login() {
    local answer="${RICE_LOGIN:-}"
    if [ -z "$answer" ]; then
        echo "How do you want to start sway?"
        echo "  1) Automatically when you log in on TTY1 (no display manager)"
        echo "  2) From a graphical login screen (LightDM with a minimal gruvbox greeter)"
        echo "  3) Neither, I'll start it myself"
        read -r -p "Choice [3]: " answer || true
    fi
    case "$answer" in
        1|tty) add_tty_login "$1" ;;
        2|dm)  add_display_manager ;;
        *)     echo "sway doesn't start by itself; see the README to start it" ;;
    esac
}

report_backup() {
    if [ -d "$BACKUP_DIR" ]; then
        echo "Your previous configs were backed up to $BACKUP_DIR"
    fi
}
