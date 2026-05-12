{
  config,
  pkgs,
  dms,
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
    extraSpecialArgs = { inherit dms inputs; };
    users.omarnix = import ../../modules/users/omarnix/home-manager.nix;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages;

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16384;
    }
  ];

  services.xserver.enable = true;
  services.desktopManager.gnome.enable = false;
  services.displayManager.gdm.enable = false;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;
  programs.firefox.enable = true;
  programs.yazi.enable = true;
  programs.niri.enable = true;
  programs.xwayland.enable = true;

  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  users.users.omarnix = {
    isNormalUser = true;
    description = "omarnix";
    extraGroups = [ "networkmanager" "wheel" "podman" ];
    shell = pkgs.zsh;
  };
}
