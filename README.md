# NixOS Configuration with Flakes

A modular NixOS flake configuration using Home Manager, Niri compositor, and DankMaterialShell.

## Overview

This configuration provides a complete NixOS setup with:
- **Niri** - Wayland compositor/window manager
- **Home Manager** - User-level configuration management
- **DankMaterialShell (DMS)** - Shell overlay with system integration
- **Zsh** - Shell with Oh My Zsh and plugins

## Folder Structure

```
nixos-config/
├── flake.nix                      # Flake inputs and outputs
├── flake.lock                     # Locked dependencies
├── hosts/
│   └── nixos/
│       ├── configuration.nix       # Main host configuration
│       └── hardware.nix            # Hardware-specific settings
├── modules/
│   └── users/
│       └── omarnix/
│           └── home-manager.nix    # Home Manager user configuration
├── overlays/                      # Package overlays (optional)
└── secrets/                        # Secrets (optional, for agenix)
```

## Components

### flake.nix
Flake definition with the following inputs:
- `nixpkgs` - NixOS unstable branch
- `home-manager` - User environment manager
- `dms` - DankMaterialShell

### hosts/nixos/configuration.nix
Main host configuration including:
- Bootloader (systemd-boot)
- X11/Wayland (Niri)
- Audio (PipeWire)
- Graphics (NVIDIA with prime offload)
- System packages
- User account definition

### hosts/nixos/hardware.nix
Auto-generated hardware configuration with:
- Kernel modules
- Firmware settings

### modules/users/omarnix/home-manager.nix
User-level Home Manager configuration:
- Zsh shell (Oh My Zsh + plugins)
- DankMaterialShell configuration
- fzf integration

## Features

### Compositor
- **Niri** - Modern Wayland compositor with tiled window management

### Shell
- **Zsh** with Oh My Zsh
- **Plugins**: git, z, sudo, zsh-autosuggestions, zsh-syntax-highlighting, fzf-tab

### Desktop Shell
- **DankMaterialShell** - Overlay shell with:
  - System monitoring (dgop)
  - Dynamic theming (matugen)
  - Audio visualizer (cava)
  - Clipboard manager
  - Systemd auto-start

### Graphics
- NVIDIA GPU with prime offload (Intel + NVIDIA)
- RTK support for audio

### Applications
- Ghostty (terminal)
- Zen Browser (web browser)
- Neovim (editor)
- Steam + Heroic (gaming)
- And many more system packages

## Usage

### Initial Setup
```bash
# Update flake dependencies
nix flake update

# Build and switch to the new configuration
sudo nixos-rebuild switch --flake .#nixos
```

### Updating the System
```bash
# Update flake inputs
nix flake update

# Rebuild
sudo nixos-rebuild switch --flake .#nixos
```

### Testing (Dry Run)
```bash
sudo nixos-rebuild switch --flake .#nixos --dry-run
```

### Rollback
```bash
# Roll back to previous generation
sudo nixos-rebuild switch --flake .#nixos --rollback
```

## Requirements

- NixOS **unstable** branch
- flake support enabled (experimental-features in nix.conf)
- EFI boot

## State Version

- NixOS: `25.11`
- Home Manager: `25.11`

## Notes

- This configuration uses the **unstable** branch of NixOS
- NVIDIA driver is set to **proprietary** (open = false) for better stability
- Prime offload is enabled for hybrid graphics (Intel + NVIDIA)
- GDM and GNOME are disabled as Niri replaces them

## License

MIT License - Feel free to use and modify as needed.