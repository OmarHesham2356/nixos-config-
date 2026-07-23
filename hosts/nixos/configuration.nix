{
  config,
  pkgs,
  inputs,
  pi-mono,
  home-manager,
  lib,
  ...
}:

{
  imports = [
    ./hardware.nix
    ../../modules/users/omarnix/common/base.nix
    inputs.home-manager.nixosModules.home-manager

    # System modules
    ../../modules/system/audio.nix
    ../../modules/system/nvidia.nix
    ../../modules/system/flatpak.nix
    ../../modules/system/steam.nix
    ../../modules/system/nix-ld.nix
    ../../modules/system/appimage.nix
    ../../modules/system/packages.nix

    # Services
    ../../modules/services/mysql.nix
    ../../modules/services/searxng.nix
    ../../modules/services/open-webui.nix
    ../../modules/services/podman.nix
    ../../modules/services/printing.nix
    ../../modules/services/bluetooth.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit pi-mono inputs; };
    users.omarnix = import ../../modules/users/omarnix/home-manager.nix;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16384;
    }
  ];

  # Blacklist nouveau so nvidia proprietary driver loads
  boot.blacklistedKernelModules = [ "nouveau" "ntfs3" ];
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelParams = [ "transparent_hugepage=never" ];

  # Auto-mount internal NTFS partition (ntfs-3g handles dirty volumes via remove_hiberfile)
  fileSystems."/mnt/backup" = {
    device = "/dev/disk/by-uuid/5CF07CCAF07CABC0";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=1000" "gid=100" "nofail" "remove_hiberfile" "big_writes" ];
  };

  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # GDM display manager
  services.displayManager.gdm.enable = true;

  # SYSTEM-WIDE ENVIRONMENT VARIABLES
  # Ensures Rofi, Hyprland, and all GUI apps inherit SANE scanner paths
  environment.variables = {
    SANE_CONFIG_DIR = "/etc/sane-config";
    SANE_PATH = "/run/current-system/sw/lib/sane";
  };

  environment.extraOutputsToInstall = [ "out" "lib" ];

  # Nix build limits — prevent builds from filling up the disk
  nix.settings = {
    min-free = 10 * 1024 * 1024 * 1024;  # 10GB: auto GC when free drops below
    max-jobs = 4;                           # Limit parallel builds
  };

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;
  programs.firefox.enable = true;

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Gamescope
  programs.gamescope = {
    enable = true;
    capSysNice = false;
  };

  # Gamemode — auto CPU/GPU optimization for games
  programs.gamemode.enable = true;

  # VMware Workstation — run virtual machines
  virtualisation.vmware.host.enable = true;

  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  # Polkit for privilege escalation prompts
  security.polkit.enable = true;

  # Auto-mount removable drives (USB, external disks)
  services.udisks2.enable = true;

  # Auto-fix dirty NTFS USB drives on plug
  systemd.services.ntfs-fix-usb = {
    description = "Fix dirty NTFS on external USB drive";
    before = [ "udisks2.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.ntfs3g}/bin/ntfsfix -d /dev/disk/by-label/Backup || true'";
    };
  };

  # udev rule to trigger ntfsfix when the Backup USB drive appears
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="block", ENV{ID_FS_LABEL}=="Backup", RUN+="${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/sleep 2 && ${pkgs.ntfs3g}/bin/ntfsfix -d /dev/%k || true'"
  '';

  # dconf service — lets GTK apps read theme settings from gsettings
  programs.dconf.enable = true;

  # XDG Desktop Portals — lets GTK apps query system configuration
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      631    # CUPS printing
    ];
    allowedUDPPorts = [
      5353   # Avahi/mDNS for printer discovery
    ];
  };

}
