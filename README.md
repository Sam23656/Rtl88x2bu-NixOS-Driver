<h1 align="center">RTL88x2BU Wi-Fi Driver for NixOS</h1>

<p align="center">
  <b>Realtek RTL88x2BU USB Wi-Fi driver packaged for NixOS</b><br/>
  Based on <a href="https://github.com/RinCat/RTL88x2BU-Linux-Driver">RinCat’s driver.</a>
</p>

<p align="center">
  <a href="https://github.com/Sam23656/Rtl88x2bu-NixOS-Driver/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/Sam23656/Rtl88x2bu-NixOS-Driver" alt="License"/>
  </a>
  <a href="https://github.com/RinCat/RTL88x2BU-Linux-Driver">
    <img src="https://img.shields.io/badge/upstream-RinCat-blue" alt="Upstream"/>
  </a>
</p>

---

## 📋 Table of Contents
- [📋 Table of Contents](#-table-of-contents)
- [📦 Features](#-features)
- [💻 Supported Devices](#-supported-devices)
- [⚙️ Usage Instructions](#️-usage-instructions)
  - [Using in NixOS Configuration](#using-in-nixos-configuration)
- [✔️ Verification](#️-verification)
- [⚡ USB 3.0 Support](#-usb-30-support)
- [⚖️ License](#️-license)
- [🔗 Upstream Repository](#-upstream-repository)

---

## 📦 Features
- ✅ **NixOS kernel-module friendly**: Integrates seamlessly with `boot.extraModulePackages`.
- 🔄 **Auto-rebuilds**: Recompiles against kernel upgrades.
- ⚙️ **Supports** RTL8812BU & RTL8822BU chipsets.
- 🛠️ **Maintained fork**: Pulls in RinCat's up-to-date fixes.

---

## 💻 Supported Devices

<details>
  <summary><b>ASUS</b></summary>

  - AC1300 USB-AC55 B1
  - U2
  - USB-AC53 Nano
  - USB-AC58
</details>

<details>
  <summary><b>D-Link</b></summary>

  - DWA-181
  - DWA-182
  - DWA-183 D Version
  - DWA-185
  - DWA-T185
</details>

<details>
  <summary><b>Edimax</b></summary>

  - EW-7822ULC
  - EW-7822UTC
  - EW-7822UAD
</details>

<details>
  <summary><b>Mercusys</b></summary>

  - MA30N
  - MA30H V2
</details>

<details>
  <summary><b>NetGear</b></summary>

  - A6150
</details>

<details>
  <summary><b>TP-Link</b></summary>

  - Archer T3U
  - Archer T3U Plus
  - Archer T3U Nano
  - Archer T4U V3
  - Archer T4U Plus
</details>

<details>
  <summary><b>TRENDnet</b></summary>

  - TEW-808UBM
</details>

<details>
  <summary><b>ZYXEL</b></summary>

  - NWD6602
</details>

… and more.

---

## ⚙️ Usage Instructions

### Using in NixOS Configuration

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Sam23656/Rtl88x2bu-NixOS-Driver
   ```

2. **Go into the repository directory**:
   ```bash
   cd Rtl88x2bu-NixOS-Driver
   ```

3. **Copy the `rtl88x2bu.nix` file** to your NixOS configuration directory:
   ```bash
   cp rtl88x2bu.nix /etc/nixos/
   ```

4. **Add the following code to `/etc/nixos/configuration.nix`:**
   ```nix
   { config, pkgs, ... }:
   let
     rtl88x2bu = pkgs.callPackage ./rtl88x2bu.nix {
       kernel = config.boot.kernelPackages.kernel;
     };
   in
   {
     imports = [
       ./hardware-configuration.nix
     ];

     boot.extraModulePackages = [ rtl88x2bu ];
     boot.kernelModules = [ "88x2bu" ];
     boot.blacklistedKernelModules = [
       "rtw88_core" "rtw88_usb" "rtw88_8822bu" "rtw88_8822b" "rtw88"
     ];
     hardware.enableRedistributableFirmware = true;

     # ... other nixos configuration
   }
   ```

5. **Rebuild your system:**
   ```bash
   sudo nixos-rebuild switch
   ```

---

## ✔️ Verification

Check if the driver is loaded:
```bash
lsmod | grep 88x2bu
```

Manually load if necessary:
```bash
sudo modprobe 88x2bu
```

Check kernel logs:
```bash
dmesg | grep 88x2bu
```

---

## ⚡ USB 3.0 Support

You can try using:
```bash
sudo modprobe 88x2bu rtw_switch_usb_mode=1
```
to force the adapter to run in USB 3.0 mode.
⚠️ If unsupported, it may cause restart loops. Remove the parameter and reload the driver to restore.

Alternatively, use:
```bash
sudo modprobe 88x2bu rtw_switch_usb_mode=2
```
to force USB 2.0 mode.

> **Important:**  
Unload the module first if it's already loaded:
```bash
sudo modprobe -r 88x2bu
```

To make this setting permanent, create `/etc/modprobe.d/99-RTL88x2BU.conf` with:
```
options 88x2bu rtw_switch_usb_mode=1
```

---

## ⚖️ License

This driver is licensed under **GNU GPL v2.0**.
See the [LICENSE](https://github.com/Sam23656/Rtl88x2bu-NixOS-Driver/blob/main/LICENSE) file for details.

---

## 🔗 Upstream Repository

[RinCat/RTL88x2BU-Linux-Driver](https://github.com/RinCat/RTL88x2BU-Linux-Driver)