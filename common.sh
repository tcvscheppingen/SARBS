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

# Offer to start sway on TTY1 from the login profile, as the Arch Wiki
# recommends. $1 is the snippet that starts sway. Sway then starts waybar,
# mako and the rest itself.
offer_sway_autostart() {
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

    read -r -p "Start sway automatically when you log in on TTY1 (adds it to $profile)? [y/N] " answer || true
    case "$answer" in
        [yY]*)
            [ -e "$profile" ] && backup "$profile"
            printf '\n# Start sway on TTY1 (added by the Gruvbox sway rice)\n%s\n' "$snippet" >> "$profile"
            echo "Added sway to $profile"
            ;;
    esac
}

report_backup() {
    if [ -d "$BACKUP_DIR" ]; then
        echo "Your previous configs were backed up to $BACKUP_DIR"
    fi
}
