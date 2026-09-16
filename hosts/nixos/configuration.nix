{
  config,
  pkgs,
  inputs,
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
    ../../modules/system/kde-speed.nix
    ../../modules/system/nvidia.nix
    ../../modules/system/flatpak.nix
    ../../modules/system/steam.nix
    ../../modules/system/nix-ld.nix
    ../../modules/system/appimage.nix
    ../../modules/system/vpn.nix
    ../../modules/system/packages.nix

    # Services
    ../../modules/services/mysql.nix
    ../../modules/services/mongodb.nix
    ../../modules/services/redis.nix
    ../../modules/services/searxng.nix
    # ../../modules/services/open-webui.nix
    ../../modules/services/podman.nix
    ../../modules/services/printing.nix
    ../../modules/services/bluetooth.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    backupFileExtension = "hm-backup";
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

  # Enable Plasma (KDE)
  services = {
    desktopManager.plasma6.enable = true;

    # Default display manager for Plasma
    displayManager.plasma-login-manager.enable = true;
  };

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

    # Windscribe GUI binary cache (from Varmisanth/windscribe-nixos) — avoids building Qt app from source
    extra-substituters = [ "https://varmisanth.cachix.org" ];
    extra-trusted-public-keys = [ "varmisanth.cachix.org-1:rt04yjDDJKDWe+h6B1XQWfdsSDUX6uks+9IKVBjn2d8=" ];
    trusted-users = [ "root" "@wheel" ];
  };

  nixpkgs.config.allowUnfree = true;

  # Windscribe — free VPN GUI with Stealth/WStunnel anti-DPI protocols
  programs.windscribe = {
    enable = true;
    users = [ "omarnix" ];
    app.autoStart = false;
  };

  programs.zsh.enable = true;
  programs.firefox.enable = true;

  # LocalSend — cross-platform AirDrop alternative (opens firewall port 53317 to receive files)
  programs.localsend.enable = true;

  # ===========================================================================
  # YubiKey
  # ===========================================================================
  # udev rules so YubiKey is accessible without root (required for all YubiKey features)
  services.udev.packages = [ pkgs.yubikey-personalization ];

  # GPG agent with SSH support — lets the YubiKey act as a smartcard for signing/SSH
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # PCSC-Lite daemon — required for YubiKey smartcard (CCID) mode and yubioath-flutter
  services.pcscd.enable = true;

  # pam_u2f — use YubiKey as a FIDO U2F second factor for login and sudo.
  # Password still works as the primary factor (unixAuth stays true).
  # NOTE: Run `pamu2fcfg > ~/.config/Yubico/u2f_keys` once, then this enables touch-to-auth.
  security.pam.services = {
    login.u2f.enable = true;
    sudo.u2f.enable = true;
  };

  programs.throne = {
    enable = true;
    tunMode = {
      enable = true;
    };
  };

  services.resolved.enable = true;

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

  # XDG Desktop Portals — lets apps query system configuration.
  # Per-session config keeps KDE and Hyprland from fighting over screen-sharing
  # requests (the hyprland portal must only act inside a Hyprland session).
  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland   # Only used when logging into Hyprland
    ];

    config = {
      # When inside a KDE Plasma session:
      kde.default = [ "kde" "gtk" ];

      # When inside a Hyprland session:
      hyprland.default = [ "hyprland" "gtk" ];

      # Fallback for anything else:
      common.default = [ "gtk" ];
    };
  };

  # Let NetworkManager set DNS directly instead of via systemd-resolved DBus,
  # so Proton's kill-switch interface (null DNS addresses) doesn't spam SetLinkDNS errors
  networking.networkmanager.dns = lib.mkForce "default";

  # OpenVPN plugin so the Proton GUI can use OpenVPN-over-TCP (network drops UDP:443 to Proton)
  networking.networkmanager.plugins = [ pkgs.networkmanager-openvpn ];

  # Native wg-quick WireGuard from Proton's raw .conf (bypasses NetworkManager/KDE parsing).
  # Drop the downloaded proton.conf at /etc/nixos/proton.conf (chmod 600), then:
  #   sudo systemctl start wg-quick-wg0   |   sudo systemctl stop wg-quick-wg0
  networking.wg-quick.interfaces = {
    wg0 = {
      configFile = "/etc/nixos/proton.conf";
      autostart = false;  # set true only after confirming the tunnel works on this network
    };
  };

  # Firewall
  networking.firewall = {
    enable = true;
    # Disabled reverse-path filtering: ProtonVPN's kill-switch wireguard routing
    # gets dropped by strict/loose rp_filter, causing "Waiting for agent status" timeouts
    checkReversePath = false;
    allowedTCPPorts = [
      631    # CUPS printing
    ];
    allowedUDPPorts = [
      5353   # Avahi/mDNS for printer discovery
    ];
  };

}
