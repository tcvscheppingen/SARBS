# SARBS - Sway Auto Rice Bootstrapping Script

<img width="1728" height="1117" alt="Screenshot 2026-10-05 at 20 02 57" src="https://github.com/user-attachments/assets/d31fcb47-a7ff-4945-86d2-9da251c47d6b" />

This repo contains my dotfiles for Sway, Waybar, mako, wmenu, Foot, swaylock, swaynag and a Neovim color theme, all using the [gruvbox](https://github.com/morhetz/gruvbox) dark palette.

It sticks close to sway and the utilities that come with it: a minimal Waybar in the style of dwm, and wmenu (the default sway launcher) instead of rofi. The key bindings are the default sway ones plus the remaps from the Birmingham theme (see [Key bindings](#key-bindings)).

The installation scripts are intended for Arch and Arch based distributions such as EndeavourOS and CachyOS, Fedora, and Artix with dinit, but the dotfiles can be used without them.

## Requirements
- Sway
- Waybar
- mako
- Foot
- wmenu
- JetBrains Mono Nerd Font
- Arch, an Arch based distribution, Fedora or Artix with dinit (to install everything with the scripts)
- LibreWolf and Thunar (optional, for the browser and file manager shortcuts)

## What the script does
**Always check the contents of a script before running it**

`auto-rice.sh` does the following:
- Installs everything a minimal install needs for a working desktop. Packages you already have are skipped.
  - Sway and its utilities: sway, swaybg, swaylock, swayidle, wmenu, foot, waybar, mako and Xwayland (for X11 apps)
  - Sound: PipeWire with its PulseAudio replacement and WirePlumber, plus `pactl` for the volume keys
  - Desktop plumbing: the wlr and GTK portals (for screen sharing and file pickers), an LXQt polkit agent (for password prompts), NetworkManager, Bluetooth (bluez and blueman) and xdg-user-dirs
  - Tools: grim, slurp and wl-clipboard for screenshots, brightnessctl and playerctl
  - Fonts and themes: the JetBrains Mono Nerd Font, Noto fonts and emoji (so websites don't show empty boxes), and the Adwaita icons and cursor
  - Apps: Neovim, Thunar and LibreWolf
  - On Arch it uses `pacman`.
  - On Fedora it uses `dnf`. It adds the [official LibreWolf repo](https://librewolf.net/installation/rhel/) to `/etc/yum.repos.d/librewolf.repo`, installs `pulseaudio-utils` for `pactl`, and downloads the JetBrains Mono Nerd Font from the [nerd-fonts releases](https://github.com/ryanoasis/nerd-fonts/releases) to `~/.local/share/fonts/`, because Fedora does not package it.
- Backs up your existing `sway`, `waybar`, `mako`, `foot`, `swaylock`, `swaynag` and `nvim` configs to `~/.config/gruvbox-rice-backup-<date>/`.
- Moves `~/.sway/config` into that backup if it exists. Sway reads that file before `~/.config/sway/config`, so leaving it would hide this theme.
- Enables NetworkManager and Bluetooth on boot. NetworkManager is skipped if `systemd-networkd` manages your network, because the two would conflict.
- Creates `~/Pictures` and the other user folders.
- Copies the dotfiles into `~/.config`.
- Asks whether sway should start when you log in on TTY1. If you say yes, it adds this to your login shell's profile and backs up the old profile first (see [Starting sway on login](#starting-sway-on-login)).

### Artix

`auto-rice-artix.sh` does the same for Artix with dinit (`auto-rice.sh` refuses to run on Artix). The differences:
- Updates `artix-keyring` and `archlinux-keyring` first, so packages signed with newer keys don't fail with signature errors on an install that hasn't been updated for a while.
- Adds Arch's `[extra]` repo to `/etc/pacman.conf` with `artix-archlinux-support`, the same way [LARBS](https://github.com/LukeSmithxyz/LARBS) does, because wmenu is not in the Artix repos. Everything else comes from the Artix repos.
- Installs the dinit services for elogind, D-Bus, NetworkManager and Bluetooth, and links them into `/etc/dinit.d/boot.d/` so they start on boot. NetworkManager is skipped if connman manages your network.
- Installs turnstile, which runs your own dinit with PipeWire, PipeWire's PulseAudio replacement, WirePlumber and the D-Bus session bus when you log in. They are linked into `~/.config/dinit.d/boot.d/`.
- Adds you to the `video` group, because Artix's brightnessctl changes the backlight through that group.
- The sway login snippet also sets `XDG_CURRENT_DESKTOP=sway`, so the portals pick the right backend.

## Installation with auto rice script

1. Clone the repo:
```bash
git clone https://github.com/tcvscheppingen/sway-dotfiles-gruvbox.git
```
2. Make the auto rice script executable:
```bash
cd sway-dotfiles-gruvbox
chmod +x auto-rice.sh
```
3. Run the installation script as the user who will use sway, not as root; it asks for your password through `sudo` when it needs root (on Artix, `chmod +x auto-rice-artix.sh` and run `./auto-rice-artix.sh` instead):
```bash
./auto-rice.sh
```
4. Reboot, so PipeWire, NetworkManager and Bluetooth start

If you prefer to install Sway and utilities manually, you can use `move-config-files.sh` to just move the config files to your home directory without installing anything. It does not set up [starting sway on login](#starting-sway-on-login).

## Manual installation

1. Clone the repo:
```bash
git clone https://github.com/tcvscheppingen/sway-dotfiles-gruvbox.git
```

2. Install the packages.

   Arch:
```bash
sudo pacman -S --needed sway swaybg swaylock swayidle wmenu foot waybar mako xorg-xwayland \
    pipewire pipewire-pulse pipewire-jack wireplumber libpulse \
    xdg-desktop-portal-wlr xdg-desktop-portal-gtk lxqt-policykit \
    networkmanager network-manager-applet bluez bluez-utils blueman \
    grim slurp wl-clipboard xdg-user-dirs brightnessctl playerctl \
    ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji \
    adwaita-icon-theme adwaita-cursors dconf \
    neovim thunar librewolf
sudo systemctl enable NetworkManager bluetooth
xdg-user-dirs-update
```

   Fedora (LibreWolf needs [its own repo](https://librewolf.net/installation/rhel/), and the JetBrains Mono Nerd Font comes from the [nerd-fonts releases](https://github.com/ryanoasis/nerd-fonts/releases)):
```bash
curl -fsSL https://repo.librewolf.net/librewolf.repo | sudo tee /etc/yum.repos.d/librewolf.repo
sudo dnf install sway swaybg swaylock swayidle wmenu foot waybar mako xorg-x11-server-Xwayland \
    pipewire pipewire-pulseaudio wireplumber pulseaudio-utils \
    xdg-desktop-portal-wlr xdg-desktop-portal-gtk lxqt-policykit \
    NetworkManager network-manager-applet bluez blueman \
    grim slurp wl-clipboard xdg-user-dirs brightnessctl playerctl \
    google-noto-sans-fonts google-noto-color-emoji-fonts \
    adwaita-icon-theme adwaita-cursor-theme dconf \
    neovim Thunar librewolf
sudo systemctl enable NetworkManager bluetooth
xdg-user-dirs-update
mkdir -p ~/.local/share/fonts/JetBrainsMonoNerdFont
curl -fL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz | tar -xJ -C ~/.local/share/fonts/JetBrainsMonoNerdFont
fc-cache -f
```

   To use a different browser, change it in `~/.config/sway/config`:
```
set $browser librewolf # Change default browser
```

3. Move the dotfiles into your home folder:
```bash
cd sway-dotfiles-gruvbox # Or wherever you cloned the repo
mkdir -p ~/.config
cp -a .config/. ~/.config/
```

4. If `~/.sway/config` exists, move or remove it. Otherwise sway will keep using it instead of `~/.config/sway/config`.

5. Optionally, [start sway on login](#starting-sway-on-login).

## Starting sway on login

Without a display manager, you can start sway from your login shell's profile when you log in on TTY1, [as the Arch Wiki recommends](https://wiki.archlinux.org/title/Sway#Automatically_on_TTY_login). You only need to start sway: it starts Waybar (`swaybar_command waybar`) and mako (`exec mako`) itself.

Add this to the end of your profile:
```bash
# Start sway on TTY1
if [ -z "$WAYLAND_DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
    exec sway
fi
```

Which file is your profile depends on your login shell (`echo $SHELL`):
- **bash**: `~/.bash_profile`. If you don't have that file but do have `~/.bash_login` or `~/.profile`, use that one instead. bash reads only the first of these it finds, so creating `~/.bash_profile` would stop it from reading `~/.profile`.
- **zsh**: `~/.zprofile` (or `$ZDOTDIR/.zprofile` if you set `ZDOTDIR`).

`auto-rice.sh` finds the right file for bash and zsh by itself. For other shells, add the equivalent to that shell's login config. For example, in fish, `~/.config/fish/config.fish`:
```fish
if status is-login; and test -z "$WAYLAND_DISPLAY"; and test "$XDG_VTNR" = 1
    exec sway
end
```

Other TTYs still give you a normal shell, so if sway fails to start you can switch to TTY2 (`ctrl + alt + F2`) to fix it.

If you use a display manager (such as GDM or SDDM), skip this and choose the Sway session on its login screen instead.

## Key bindings

On top of the default sway bindings, these come from the Birmingham theme:

| Keys | Action |
|---|---|
| `mod + w` | Open the browser (LibreWolf) |
| `mod + r` | Open the file manager (Thunar) |
| `mod + q` | Close the focused window |
| `mod + n` | Thin window border (3px) |
| `mod + m` | Normal window border with a title bar |
| `mod + u` / `mod + p` | Shrink / grow the window width |
| `mod + o` / `mod + i` | Shrink / grow the window height |

To make room for these, `mod + w` no longer switches to tabbed layout, `mod + s` no longer switches to stacking layout, and the `mod + r` resize mode is gone.

This theme adds:

| Keys | Action |
|---|---|
| `mod + x` | Lock the screen |
| `mod + Escape` / `mod + shift + Escape` | Dismiss the newest / all notifications |
| `Print` | Screenshot of all screens, saved to `~/Pictures` |
| `shift + Print` | Screenshot of an area you select, saved to `~/Pictures` |
| `ctrl + Print` / `ctrl + shift + Print` | The same, but copied to the clipboard |
| Play, next and previous keys | Control music and video players (playerctl) |

## Screen locking

swayidle locks the screen with swaylock after 5 minutes without input, turns the displays off 5 minutes later, and locks the screen before the computer goes to sleep. Change the times in the `### Idle configuration` section of `~/.config/sway/config`.

## Look of other apps

Sway sets the Adwaita cursor, and sets GTK apps such as Thunar and LibreWolf's dialogs to dark mode with `gsettings` every time it starts or reloads. Qt apps, such as the LXQt password prompt, keep their default look.

## Wallpaper

No wallpaper is included. Sway shows a solid gruvbox background (`#282828`) until you add one:

1. Put your image at `~/.config/sway/wallpaper.jpg`.
2. In `~/.config/sway/config`, comment out the `solid_color` line and uncomment the wallpaper line below it:
```
# output * bg $bg0 solid_color
output * bg ~/.config/sway/wallpaper.jpg fill
```
3. Reload Sway (`mod + shift + c`).

## Notifications

mako shows notifications in the top right corner, with a yellow border, or a red one for critical notifications. They disappear after 5 seconds; critical ones stay until you dismiss them. Click a notification or press `mod + Escape` to dismiss the newest one, or `mod + shift + Escape` to dismiss all of them. The config is in `~/.config/mako/config`. Run `makoctl reload` after changing it.

## Status bar

Sway starts Waybar (`swaybar_command waybar`) instead of swaybar. It is a minimal, plain text bar in the style of dwm and slstatus: workspaces and the binding mode on the left, and on the right the wifi connection, the volume (click it to mute), the battery (on laptops), memory use, the date, the current time (`HH:MM:SS`), split by `|`, and the system tray with the wifi and Bluetooth icons. The config is in `~/.config/waybar/config.jsonc` and the colors are in `~/.config/waybar/style.css`.

## Palette

| Role | Color |
|---|---|
| Background (hard) | `#1D2021` |
| Background | `#282828` |
| Background 1 | `#3C3836` |
| Background 2 | `#504945` |
| Foreground | `#EBDBB2` |
| Gray | `#928374` |
| Red | `#FB4934` |
| Green | `#B8BB26` |
| Yellow | `#FABD2F` |
| Blue | `#83A598` |
| Purple | `#D3869B` |
| Aqua | `#8EC07C` |
| Orange | `#FE8019` |

## Credits

Gruvbox palette: [morhetz/gruvbox](https://github.com/morhetz/gruvbox)
