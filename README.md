# Sway Auto Rice - Gruvbox Theme

This repo contains my dotfiles for Sway, Waybar, wmenu, Foot, swaylock, swaynag and a Neovim color theme, all using the [gruvbox](https://github.com/morhetz/gruvbox) dark palette.

It sticks close to sway and the utilities that come with it: a minimal Waybar in the style of dwm, and wmenu (the default sway launcher) instead of rofi. The key bindings are the default sway ones plus the remaps from the Birmingham theme (see [Key bindings](#key-bindings)).

The installation script is intended for Arch and Arch based distributions such as EndeavourOS and CachyOS, and for Fedora, but the dotfiles can be used without the script.

## Requirements
- Sway
- Waybar
- Foot
- wmenu
- JetBrains Mono Nerd Font
- Arch, an Arch based distribution or Fedora (to install everything with the script)
- LibreWolf and Thunar (optional, for the browser and file manager shortcuts)

## What the script does
**Always check the contents of a script before running it**

`auto-rice.sh` does the following:
- Installs sway, swaybg, swaylock, swayidle, wmenu, foot, waybar, grim, brightnessctl, `pactl`, the JetBrains Mono Nerd Font, Neovim, Thunar and LibreWolf. Packages you already have are skipped.
  - On Arch it uses `pacman`.
  - On Fedora it uses `dnf`. It adds the [official LibreWolf repo](https://librewolf.net/installation/fedora/) to `/etc/yum.repos.d/librewolf.repo`, installs `pulseaudio-utils` for `pactl`, and downloads the JetBrains Mono Nerd Font from the [nerd-fonts releases](https://github.com/ryanoasis/nerd-fonts/releases) to `~/.local/share/fonts/`, because Fedora does not package it.
- Backs up your existing `sway`, `waybar`, `foot`, `swaylock`, `swaynag` and `nvim` configs to `~/.config/gruvbox-rice-backup-<date>/`.
- Moves `~/.sway/config` into that backup if it exists. Sway reads that file before `~/.config/sway/config`, so leaving it would hide this theme.
- Copies the dotfiles into `~/.config`.

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
3. Run the installation script:
```bash
./auto-rice.sh
```
4. Reload Sway (`mod + shift + c`)

If you prefer to install Sway and utilities manually, you can use `move-config-files.sh` to just move the config files to your home directory without installing anything.

## Manual installation

1. Clone the repo:
```bash
git clone https://github.com/tcvscheppingen/sway-dotfiles-gruvbox.git
```

2. Install the packages.

   Arch:
```bash
sudo pacman -S --needed sway swaybg swaylock swayidle wmenu foot waybar grim brightnessctl libpulse ttf-jetbrains-mono-nerd neovim thunar librewolf
```

   Fedora (LibreWolf needs [its own repo](https://librewolf.net/installation/fedora/), and the JetBrains Mono Nerd Font comes from the [nerd-fonts releases](https://github.com/ryanoasis/nerd-fonts/releases)):
```bash
curl -fsSL https://repo.librewolf.net/librewolf.repo | sudo tee /etc/yum.repos.d/librewolf.repo
sudo dnf install sway swaybg swaylock swayidle wmenu foot waybar grim brightnessctl pulseaudio-utils neovim thunar librewolf
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

## Wallpaper

No wallpaper is included. Sway shows a solid gruvbox background (`#282828`) until you add one:

1. Put your image at `~/.config/sway/wallpaper.jpg`.
2. In `~/.config/sway/config`, comment out the `solid_color` line and uncomment the wallpaper line below it:
```
# output * bg $bg0 solid_color
output * bg ~/.config/sway/wallpaper.jpg fill
```
3. Reload Sway (`mod + shift + c`).

## Status bar

Sway starts Waybar (`swaybar_command waybar`) instead of swaybar. It is a minimal, plain text bar in the style of dwm and slstatus: workspaces and the binding mode on the left, and on the right the wifi connection, the battery (on laptops), memory use, the date, the current time (`HH:MM:SS`), split by `|`, and the system tray. The config is in `~/.config/waybar/config.jsonc` and the colors are in `~/.config/waybar/style.css`.

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
