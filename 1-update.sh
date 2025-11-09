#!/usr/bin/env bash
# =============================================================================
# Fedora Post-Install Script — Update on Nov'25
# Run: sudo ./1-update.sh
# =============================================================================

set -euo pipefail
IFS=$'\n\t'

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
log()   { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*">&2; }

[[ $EUID -eq 0 ]] || { error "Run with sudo"; exit 1; }

log "Starting Fedora setup..."

# === 1. Custom dnf.conf (with backup) ==============================
if [[ -f ./dotfiles/dnf.conf ]]; then
    cp -a /etc/dnf/dnf.conf /etc/dnf/dnf.conf.backup.$(date +%F_%H%M%S)
    log "Backed up original dnf.conf"
    cp -a ./dotfiles/dnf.conf /etc/dnf/dnf.conf
    log "Custom dnf.conf installed"
fi

# === 2. RPM Fusion =================================================
log "Adding RPM Fusion repositories..."
dnf install -y \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
  || log "RPM Fusion already present — continuing"

# === 3. Flathub ====================================================
log "Adding Flathub..."
flatpak remote-add --if-not-exists --system flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# === 4. Cisco OpenH264 =============================================
log "Enabling fedora-cisco-openh264..."
dnf config-manager setopt fedora-cisco-openh264.enabled=1

# === 5. GROUP UPDATE/UPGRADE SECTION (your exact commands) ========
log "Running YOUR exact group update/upgrade commands..."

dnf update @core -y                                || warn "dnf update @core failed (maybe already up-to-date)"
dnf install rpmfusion-*-appstream-data -y          || warn "appstream data already installed"
dnf group upgrade core -y                          || warn "group upgrade core not needed"
dnf4 group install core -y 2>/dev/null             || true
# ===================================================================
log "Full system upgrade (final pass)..."
dnf upgrade -y --refresh

log "System is now 100% updated!"

# === 6. Reboot with countdown ======================================
echo
warn "REBOOTING IN 15 SECONDS — Press Ctrl+C to cancel!"
for i in {15..1}; do
    printf "\r${YELLOW}Rebooting in %2d seconds... (Ctrl+C to abort)${NC} " $i
    sleep 1
done

echo -e "\n${GREEN}Rebooting now!${NC}"
sync
reboot
