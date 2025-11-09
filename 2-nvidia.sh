#!/usr/bin/env bash
# =============================================================================
# Fedora NVIDIA Install Script — Update on Nov'25
# Run: sudo ./2-nvidia.sh
# =============================================================================

set -euo pipefail
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; NC='\033[0m'

log()   { echo -e "${GREEN}[NVIDIA]${NC} $*"; }
warn()  { echo -e "${YELLOW}[!]${NC} $*"; }
info()  { echo -e "${BLUE}[i]${NC} $*"; }

[[ $EUID -eq 0 ]] || { echo -e "${RED}Run with sudo!${NC}"; exit 1; }

log "Installing NVIDIA drivers + CUDA + VAAPI (akmod = auto-rebuild)"

dnf upgrade -y --refresh

dnf install -y \
    akmod-nvidia \
    xorg-x11-drv-nvidia \
    xorg-x11-drv-nvidia-cuda \
    xorg-x11-drv-nvidia-cuda-libs \
    xorg-x11-drv-nvidia-libs \
    libva-nvidia-driver \
    nvidia-vaapi-driver \
    || true

log "Installation complete. Now waiting for akmod to build kernel modules..."

echo
echo -e "${YELLOW}PLEASE WAIT 5–10 MINUTES (do NOT reboot yet!)${NC}"
echo -e "${YELLOW}The akmod-nvidia package is compiling the driver for your current kernel${NC}"
echo

# === Live progress indicator ===
seconds_waited=0
while true; do
    if modinfo -F version nvidia >/dev/null 2>&1; then
        DRIVER_VER=$(modinfo -F version nvidia)
        echo -e "\n${GREEN}SUCCESS! NVIDIA module built → version $DRIVER_VER${NC}"
        echo
        echo -e "${GREEN}You can now safely reboot${NC}"
        echo -e "${GREEN}Run: ${YELLOW}sudo reboot${NC}"
        echo
        echo -e "${BLUE}To double-check anytime:  modinfo -F version nvidia${NC}"
        exit 0
    fi

    # Pretty spinner + timer
    minutes=$((seconds_waited / 60))
    case $((seconds_waited % 4)) in
        0) spin="⠋" ;; 1) spin="⠙" ;; 2) spin="⠹" ;; 3) spin="⠸" ;;
    esac
    printf "\r${YELLOW}%s Building NVIDIA module... %dm%02ds elapsed (Ctrl+C to give up)${NC}" \
           "$spin" "$minutes" "$((seconds_waited % 60))"
    sleep 10
    ((seconds_waited += 10))
done
