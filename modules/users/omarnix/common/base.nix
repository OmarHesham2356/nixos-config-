{ lib, pkgs, ... }:

{
  # User account definition — single source of truth
  users.users.omarnix = {
    isNormalUser = true;
    description = "omarnix";
    extraGroups = [
      "networkmanager"
      "wheel"
      "podman"
      "lp"       # CUPS printing
      "scanner"  # SANE scanning
    ];
    shell = pkgs.zsh;
  };

  # Time zone
  time.timeZone = "Africa/Cairo";

  # Internationalization
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Network
  networking.hostName = "nixos";
  networking.networkmanager.enable = lib.mkDefault true;

  # Nix settings
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings = {
    auto-optimise-store = true;
  };

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # State version
  system.stateVersion = "25.11";
}