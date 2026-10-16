# Sway Auto Rice Bootstrapping Script (SARBS)

![sway with Neovim, a shell and a floating fastfetch window](screenshot.png)

This repo contains my dotfiles for Sway, Waybar, mako, wmenu, Foot, swaylock, swaynag and Neovim and Helix color themes, all in Monolith: a flat, mostly black, grey and white palette with one concrete accent, made around the brutalist wallpaper (see [Palette](#palette)).

![Opening terminals, the launcher, switching workspaces and floating a window](demo.gif)

It sticks close to sway and the utilities that come with it: a flat Waybar strip floating above the windows, and wmenu (the default sway launcher) instead of rofi. The key bindings are the default sway ones plus a few additions (see [Key bindings](#key-bindings)).

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
  - Tools: grim, slurp and wl-clipboard for screenshots, brightnessctl and playerctl, jq and libnotify for the `sysact` and `displayselect` menus, and wf-recorder and ffmpeg for screen recording
  - Fonts and themes: the JetBrains Mono Nerd Font, Noto fonts and emoji (so websites don't show empty boxes), and the Adwaita icons and cursor
  - Apps: Neovim, Thunar and LibreWolf
  - On Arch it uses `pacman`.
  - On Fedora it uses `dnf`. It adds the [official LibreWolf repo](https://librewolf.net/installation/rhel/) to `/etc/yum.repos.d/librewolf.repo`, installs `pulseaudio-utils` for `pactl`, and downloads the JetBrains Mono Nerd Font from the [nerd-fonts releases](https://github.com/ryanoasis/nerd-fonts/releases) to `~/.local/share/fonts/`, because Fedora does not package it.
- Backs up your existing `sway`, `waybar`, `mako`, `foot`, `swaylock`, `swaynag`, `nvim` and `helix` configs to `~/.config/sarbs-backup-<date>/`.
- Moves `~/.sway/config` into that backup if it exists. Sway reads that file before `~/.config/sway/config`, so leaving it would hide this theme.
- Enables NetworkManager and Bluetooth on boot. NetworkManager is skipped if `systemd-networkd` manages your network, because the two would conflict.
- Creates `~/Pictures` and the other user folders.
- Copies the dotfiles into `~/.config`, and the `sysact`, `displayselect`, `wmenurecord`, `grimpick`, `setbg` and `sound-fix` scripts into `~/.local/bin`. It links `~/.local/share/bg` to the wallpaper, unless you already picked one with `setbg`.
- Asks how sway should start: automatically when you log in on TTY1 (it adds that to your login shell's profile and backs up the old profile first), or from a graphical login screen: LightDM with a minimal greeter (see [Starting sway on login](#starting-sway-on-login)).

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
git clone https://github.com/tcvscheppingen/SARBS.git
```
2. Make the auto rice script executable:
```bash
cd SARBS
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
git clone https://github.com/tcvscheppingen/SARBS.git
```

2. Install the packages.

   Arch:
```bash
sudo pacman -S --needed sway swaybg swaylock swayidle wmenu foot waybar mako xorg-xwayland \
    pipewire pipewire-pulse pipewire-jack wireplumber libpulse \
    xdg-desktop-portal-wlr xdg-desktop-portal-gtk lxqt-policykit \
    networkmanager network-manager-applet bluez bluez-utils blueman \
    grim slurp wl-clipboard xdg-user-dirs brightnessctl playerctl jq libnotify file \
    wf-recorder ffmpeg \
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
    grim slurp wl-clipboard xdg-user-dirs brightnessctl playerctl jq libnotify file \
    wf-recorder /usr/bin/ffmpeg \
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
cd SARBS # Or wherever you cloned the repo
mkdir -p ~/.config ~/.local/bin ~/.local/share
cp -a .config/. ~/.config/
cp -a .local/bin/. ~/.local/bin/
ln -s ~/.config/sway/wallpaper.jpg ~/.local/share/bg
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

### A graphical login screen

If you answer `2` to the script's question, it installs LightDM with lightdm-gtk-greeter instead, kept minimal: the wallpaper, a login box in dark Adwaita and a panel with only the host name, the clock and the power menu (`/etc/lightdm/lightdm-gtk-greeter.conf`). Sway is the default session. LightDM is not enabled when another display manager already starts on boot.

To answer the question in advance, for example from another script, set `RICE_LOGIN` to `tty`, `dm` or `none`:
```bash
RICE_LOGIN=dm ./auto-rice.sh
```

## Key bindings

On top of the default sway bindings, this theme adds:

| Keys | Action |
|---|---|
| `mod + w` | Open the browser (LibreWolf) |
| `mod + r` | Open the file manager (Thunar) |
| `mod + q` | Close the focused window |
| `mod + n` | Thin window border (3px) |
| `mod + m` | Normal window border with a title bar |
| `mod + u` / `mod + p` | Shrink / grow the window width |
| `mod + o` / `mod + i` | Shrink / grow the window height |
| `mod + x` | Lock the screen |
| `mod + Backspace` | System menu: lock, leave or reload sway, sleep, reboot, shutdown, display off (`sysact`) |
| `mod + F3` | Display menu: use one display, or place several side by side (`displayselect`) |
| `mod + Print` | Recording menu: screen with or without microphone, a selected area, audio only, or the webcam (`wmenurecord`). Recordings go to `~/Videos` |
| `mod + shift + Print` / `mod + Delete` | Stop the recording |
| `mod + Escape` / `mod + shift + Escape` | Dismiss the newest / all notifications |
| `Print` | Screenshot of all screens, saved to `~/Pictures` |
| `shift + Print` | Screenshot menu: a selected area, the focused window or all screens, saved to `~/Pictures` or copied to the clipboard (`grimpick`). With tesseract installed it can also copy the text in an area |
| `ctrl + Print` / `ctrl + shift + Print` | Screenshot of all screens / a selected area, copied to the clipboard |
| Play, next and previous keys | Control music and video players (playerctl) |

To make room for these, `mod + w` no longer switches to tabbed layout, `mod + s` no longer switches to stacking layout, and the `mod + r` resize mode is gone.

## Scripts

Besides the menus in the key bindings, `~/.local/bin` has:
- `setbg`: `setbg image.jpg` sets the wallpaper, `setbg folder` picks a random image from a folder. Sway shows the image `~/.local/share/bg` links to, so the choice stays after a restart.
- `sound-fix`: when the volume shows no sound card ("Dummy Output") on a laptop with Intel sound, the SOF driver may not work. Run `sound-fix` in a terminal: it checks whether that's the case and offers to switch to the older HDA driver (the built-in digital microphones don't work with it). Reboot afterwards. `sound-fix sof` switches back.

## Screen locking

swayidle locks the screen with swaylock after 5 minutes without input, turns the displays off 5 minutes later, and locks the screen before the computer goes to sleep. Change the times in the `### Idle configuration` section of `~/.config/sway/config`.

## Look of other apps

Sway sets the Adwaita cursor, and sets GTK apps such as Thunar and LibreWolf's dialogs to dark mode with `gsettings` every time it starts or reloads. Qt apps, such as the LXQt password prompt, keep their default look.

## Notifications

mako shows notifications in the top right corner, with a concrete border, or a brick-red one for critical notifications. They disappear after 5 seconds; critical ones stay until you dismiss them. Click a notification or press `mod + Escape` to dismiss the newest one, or `mod + shift + Escape` to dismiss all of them. The config is in `~/.config/mako/config`. Run `makoctl reload` after changing it.

## Status bar

Sway starts Waybar (`swaybar_command waybar`) instead of swaybar. It is a flat strip that floats 10px below the top of the screen, lined up with the windows, with a thin concrete line along its bottom. Waybar reserves that space, so windows never go underneath it and keep the same 10px gap. On the left are the workspaces, the binding mode and the focused window's title; on the right the wifi connection, a brick-red `REC`, `MIC` or `CAM` while `wmenurecord` is recording, the volume (click it to mute), the battery (on laptops), memory use, the date and the time, each with a small grey label and split by `/`, and the system tray with the wifi and Bluetooth icons. The config is in `~/.config/waybar/config.jsonc` and the colors are in `~/.config/waybar/style.css`.

## Palette

Monolith is made for SARBS: black, greys and white, with one accent, the concrete of the wallpaper's blocks. The code and terminal colors are greys with a faint tint from the same photo, told apart mostly by brightness, so they stay calm without looking alike.

| Role | Color | Used for |
|---|---|---|
| Background | `#121212` | Bar, terminal, menus, notifications, Neovim and Helix |
| Border | `#2a2a2a` | Unfocused windows |
| Muted | `#7a7a7a` | Bar labels, window title, operators |
| Text | `#d0d0d0` | Bar and terminal text |
| Accent: concrete | `#8a7d74` | Focused window, active workspace, the line under the bar, wmenu, notifications |
| Keyword | `#9a9a9a` | Keywords (bold) |
| String: dusk sky | `#c2aeb0` | Strings |
| Number: mauve | `#a99bb0` | Numbers and constants |
| Type: storm clouds | `#8b97ab` | Types |
| Preprocessor | `#a39184` | `#include`, macros and attributes |
| Warning: the ledge | `#b3a48a` | Warnings |
| Error: brick | `#a8665e` | Errors, recording, critical notifications |

The colors are set in each program's own config: `~/.config/sway/config` (window borders and wmenu), `~/.config/waybar/style.css` and `config.jsonc` (the bar labels), `~/.config/foot/foot.ini` (the 16 terminal colors), `~/.config/mako/config`, `~/.config/swaylock/config`, `~/.config/swaynag/config`, the menu scripts in `~/.local/bin`, `~/.config/nvim/colors/monolith.lua` and `~/.config/helix/themes/monolith.toml`. The script doesn't install [Helix](https://helix-editor.com); its theme is used once you do.

## Credits
- Wallpaper: [a reflection of a building in a body of water](https://unsplash.com/photos/a-reflection-of-a-building-in-a-body-of-water-1jyHQxBAE7A) on Unsplash
- `sysact`, `displayselect`, `wmenurecord`, `grimpick` and `setbg` are Wayland versions of `sysact`, `displayselect`, `dmenurecord`, `maimpick` and `setbg` in Luke Smith's [voidrice](https://github.com/LukeSmithxyz/voidrice) (from [LARBS](https://larbs.xyz))
