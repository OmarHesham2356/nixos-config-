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
  boot.blacklistedKernelModules = [ "nouveau" ];

  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # GDM display manager
  services.displayManager.gdm.enable = true;

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;
  programs.firefox.enable = true;

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  # Polkit for privilege escalation prompts
  security.polkit.enable = true;

}
