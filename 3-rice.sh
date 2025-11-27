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

# === Optional hostname change ===
echo
read -p "Do you want to change the system hostname? (y/n): " change_host

if [[ "$change_host" =~ ^[Yy]$ ]]; then
    read -p "Enter the new hostname: " NEW_HOSTNAME
    if [[ -n "$NEW_HOSTNAME" ]]; then
        hostnamectl set-hostname "$NEW_HOSTNAME"
        log "Hostname set to $NEW_HOSTNAME"
    else
        warn "No hostname entered. Skipping hostname change."
    fi
else
    info "Skipping hostname change."
fi

# === Hardware clock time preference ===
echo
read -p "Do you want to use UTC time for the hardware clock? (y/n): " use_utc

if [[ "$use_utc" =~ ^[Yy]$ ]]; then
    timedatectl set-local-rtc 0
    log "UTC time is set for the hardware clock."
else
    timedatectl set-local-rtc 1
    log "Local time is set for the hardware clock."
fi

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

# === 2. Copr repos ===
log "Enabling your Copr repos..."
for repo in \
    che/zed \
    alternateved/eza \
    atim/starship \
    lihaohong/yazi \
    sneexy/zen-browser \
    scottames/ghostty \
    dejan/lazygit \
; do
    dnf copr enable -y "$repo" && log "Enabled $repo" || warn "$repo already enabled"
done

# === 3. Install your apps ===
log "Installing your apps..."
dnf install -y \
    unzip p7zip p7zip-plugins unrar \
    zed eza starship yazi zen-browser ghostty \
    zsh bat neovim git fastfetch fzf zoxide lazygit

# === 4. System tweaks ===
log "Applying system tweaks..."
grubby --update-kernel=ALL --args="nvidia-drm.modeset=1"
systemctl disable NetworkManager-wait-online.service 2>/dev/null || true

rm -f /usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js
rm -f /etc/xdg/autostart/org.gnome.Software.desktop

# === 5. Deploy dotfiles ===
log "Deploying dotfiles for $SUDO_USER..."

USER_HOME=$(eval echo ~$SUDO_USER)
BACKUP_DATE=$(date +%d%m%Y)

backup_or_replace() {
    local target="$1"
    if [ -e "$target" ]; then
        echo
        warn "'$target' already exists."
        read -p "Do you want to backup instead of replacing? (y/n): " ans
        if [[ "$ans" =~ ^[Yy]$ ]]; then
            local backup="${target}_BAK_${BACKUP_DATE}"
            mv "$target" "$backup"
            log "Backup created: $backup"
        else
            rm -rf "$target"
            log "Removed existing: $target"
        fi
    fi
}

# Clone ZSH plugins
backup_or_replace "$USER_HOME/.zsh" 
for plugin in zsh-completions zsh-history-substring-search zsh-syntax-highlighting zsh-autosuggestions
do
    sudo -u "$SUDO_USER" git clone \
        "https://github.com/zsh-users/$plugin.git" \
        "$USER_HOME/.zsh/plugins/$plugin"
done

# Clone NeoVim config
backup_or_replace "$USER_HOME/.config/nvim"
sudo -u "$SUDO_USER" git clone \
    https://github.com/BimalShukla/Neovim-Config.git \
    "$USER_HOME/.config/nvim"

# Clone Fastfetch config
backup_or_replace "$USER_HOME/.config/fastfetch"
sudo -u "$SUDO_USER" git clone \
    https://github.com/BimalShukla/Fastfetch-Config.git \
    "$USER_HOME/.config/fastfetch"

# Handle dotfiles
for df in .zshrc .bashrc; do
    if [ -f "$USER_HOME/$df" ]; then
        warn "File '$df' exists."
        read -p "Backup existing $df? (y/n): " ans
        if [[ "$ans" =~ ^[Yy]$ ]]; then
            mv "$USER_HOME/$df" "$USER_HOME/${df}_BAK_${BACKUP_DATE}"
            log "Backed up $df"
        else
            rm -f "$USER_HOME/$df"
            log "Replaced $df"
        fi
    fi
done

sudo -u "$SUDO_USER" cp -r ./dotfiles/home/{.zshrc,.bashrc} "$USER_HOME/"
sudo -u "$SUDO_USER" cp -r ./dotfiles/config/* "$USER_HOME/.config/"
sudo -u "$SUDO_USER" cp -r ./dotfiles/fonts "$USER_HOME/.local/share/"

# Permissions
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
