#!/usr/bin/env bash
# =============================================================================
# Fedora Rice Script — Update on Nov'25
# Run: sudo ./3-rice.sh
# =============================================================================

set -euo pipefail
IFS=$'\n\t'

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'
log()   { echo -e "${GREEN}[CONFIG]${NC} $*"; }
warn()  { echo -e "${YELLOW}[!]${NC} $*"; }
info()  { echo -e "${BLUE}[i]${NC} $*"; }

[[ $EUID -eq 0 ]] || { echo -e "${RED}ERROR: Run with sudo${NC}"; exit 1; }

read -p "Enter the desired hostname: " NEW_HOSTNAME
hostnamectl set-hostname "$NEW_HOSTNAME" 
log "Hostname set to $NEW_HOSTNAME"
timedatectl set-local-rtc 0

# === 1. Full multimedia liberation ===
log "Unleashing full multimedia power..."
dnf4 group install multimedia -y 2>/dev/null || dnf group install multimedia -y
dnf swap ffmpeg-free ffmpeg --allowerasing -y
dnf update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
dnf group install -y sound-and-video

dnf install -y \
    rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted \
    libva-intel-driver ffmpeg-libs libva libva-utils

dnf --repo=rpmfusion-nonfree-tainted install "*-firmware" -y

dnf install -y openh264 gstreamer1-plugin-openh264 mozilla-openh264 libdvdcss
dnf config-manager setopt fedora-cisco-openh264.enabled=1

# === 2. Copr repos (your favorite tools) ===
log "Enabling your Copr repos..."
for repo in \
    che/zed \
    alternateved/eza \
    atim/starship \
    lihaohong/yazi \
    sneexy/zen-browser \
    scottames/ghostty \
; do
    dnf copr enable -y "$repo" && log "Enabled $repo" || warn "$repo already enabled"
done

# === 3. Install your apps ===
log "Installing your apps..."
dnf install -y \
    unzip p7zip p7zip-plugins unrar \
    zed eza starship yazi zen-browser ghostty \
    zsh bat neovim git fastfetch fzf zoxide

# === 4. System tweaks ===
log "Applying system tweaks..."
grubby --update-kernel=ALL --args="nvidia-drm.modeset=1"
systemctl disable NetworkManager-wait-online.service 2>/dev/null || true

rm -f /usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js
rm -f /etc/xdg/autostart/org.gnome.Software.desktop

# === 5. Deploy dotfiles ===
log "Deploying dotfiles for $SUDO_USER..."
USER_HOME=$(eval echo ~$SUDO_USER)    # works even if user has weird home dir

shopt -s nullglob dotglob
cp -r ./dotfiles/home/*    "$USER_HOME"/
cp -r ./dotfiles/config/*  "$USER_HOME/.config/"
cp -r ./dotfiles/fonts     "$USER_HOME/.local/share/"

chown -R "$SUDO_USER:$SUDO_USER" "$USER_HOME"/{.config,.local,.*} 2>/dev/null || true
fc-cache -fv >/dev/null 2>&1 || true

log "Dotfiles deployed to $USER_HOME"

# === 6. Set zsh as default ===
log "Setting zsh as default shell"
chsh -s /usr/bin/zsh $SUDO_USER

# === 7. Final update ===
log "Final system refresh..."
dnf upgrade -y --refresh

# === DONE ===
clear
echo
echo -e "${GREEN}        ██████╗  ██████╗ ███╗   ██╗███████╗"
echo -e "${GREEN}        ██╔══██╗██╔═══██╗████╗  ██║██╔════╝"
echo -e "${GREEN}        ██║  ██║██║   ██║██╔██╗ ██║█████╗  "
echo -e "${GREEN}        ██║  ██║██║   ██║██║╚██╗██║██╔══╝  "
echo -e "${GREEN}        ██████╔╝╚██████╔╝██║ ╚████║███████╗"
echo -e "${GREEN}        ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝${NC}"
echo
echo -e "${YELLOW}       YOUR FEDORA IS CONFIGURED NOW${NC}"
echo
echo -e "${GREEN}   All done! You may now close this terminal.${NC}"
echo
