# 🐧 Fedora Post-Installation & Configuration Scripts  
🗓️ **Updated on:** November, 2025  

Automated scripts to help you quickly set up a ready-to-use **Fedora** environment.

---

## 🚀 Features

1. **Enable third-party repositories** (RPM & Flatpak)  
2. **Update the system** automatically  
3. **Safely install NVIDIA drivers** with additional utilities  
4. **Optionally install common packages** along with their configuration files  

These scripts simplify post-installation setup and ensure a smooth Fedora experience right from the start.

---

## 📁 Repository Structure

```
Fedora-Config/
├── 1-update.sh              # Enables 3rd-party repos and updates the system
├── 2-nvidia.sh              # Installs NVIDIA proprietary driver safely with extra utilities
├── 3-rice.sh                # Installs and configures common packages/applications
├── dotfiles/
│   ├── config/              # Configuration files for installed packages
│   ├── fonts/               # Fonts used by the setup
│   └── home/                # Shell configs (ZSH & Bash)
└── README.md
```

---

## 🧩 Usage

1. **Clone the repository:**
   ```bash
   git clone https://github.com/<your-username>/Fedora-Config.git
   cd Fedora-Config
   ```

2. **Grant permission to make the scripts executable:**
   ```bash
   chmod +x *.sh
   ```
       
3. **Run scripts 1-update.sh:**
   ```bash
   sudo ./1-update.sh
   ```
   - After execution complete -> Reboot
  
4. **Run scripts 2-nvidia.sh:**
   ```bash
   sudo ./2-nvidia.sh
   ```
   - After execution complete -> Wait for 5 min -> Reboot
  
5. **Run scripts 3-rice.sh (Optional):**
   ```bash
   sudo ./3-rice.sh
   ```

   **Important Notes:**
   - Run the scripts **one by one** — do **not** run them all at once.  
   - **Sudo privileges** are required to execute these scripts.  
   - Execute them **in order**:  
     `1 → 2 → (3 optional)`  
   - After running **1-update.sh**, **reboot** your system.  
   - Then, run **2-nvidia.sh** to safely install NVIDIA drivers.  
     Wait for atleast **5 minutes** before rebooting, to let the kernel module get built.
     Run `modinfo -F version nvidia` to check if the kernel module is built, then **reboot**.
   - **3-rice.sh** is optional — It installs additional packages and applies configurations.
   - **(Optional)** Review or edit configuration files in the `dotfiles/` directory before running the scripts.

---

## ⚠️ Notes

- Designed and tested for **Fedora 42+**  
- Always review scripts before running them  
- Use at your own discretion — especially the NVIDIA driver script  
