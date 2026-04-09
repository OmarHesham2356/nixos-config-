# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

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
    # Hardware configuration
    ./hardware.nix

    # Common base module
    ../../modules/users/omarnix/common/base.nix
    # 1. Import the Home Manager NixOS module from flake inputs
    inputs.home-manager.nixosModules.home-manager
  ];

  # 2. Configure Home Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    # This passes 'dms' (and others) into your home-manager.nix file
    extraSpecialArgs = { inherit dms inputs; };

    users.omarnix = import ../../modules/users/omarnix/home-manager.nix;
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages;

  # Configure a swap file to prevent out-of-memory (OOM) issues
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16384;
    }
  ];

  # Enable X11 windowing system
  services.xserver.enable = true;

  # Disable GNOME Desktop - we use niri as compositor/wm
  services.desktopManager.gnome.enable = false;
  services.displayManager.gdm.enable = false;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents
  services.printing.enable = true;

  # Enable sound with pipewire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  #Install Firefox
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # 1. Enable Zsh system-wide
  programs.zsh.enable = true;

  users.users.omarnix = {
    isNormalUser = true;
    description = "omarnix";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    # 2. Set Zsh as the default shell
    shell = pkgs.zsh;
  };

  #Power management
  services.upower.enable = true;
  
  # Also ensure power-profiles-daemon is active (which shows in your screenshot)
  services.power-profiles-daemon.enable = true;

  # Flatpak
  services.flatpak.enable = true;

  # Nvidia
  hardware.graphics = {
  enable = true;
  enable32Bit = true; # Required for many game launchers
};
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = false;
    modesetting.enable = true;
    nvidiaSettings = true;
    powerManagement.enable = true;

    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # MySQL Workbench
  services.mysql = {
    enable = true;
    package = pkgs.mysql84;
  };

  # fwupd
  services.fwupd.enable = true;

  # Niri compositor
  programs.niri.enable = true;

  # Ensure Xwayland is supported
  programs.xwayland.enable = true;

  #nix-ld for better performance with Nvidia drivers
  programs.nix-ld.enable = true;


  services.open-webui = {
    enable = true;
    port = 8080; # You can choose any port
  };

    
  # System packages
  environment.systemPackages = with pkgs; [
    baobab
    bat
    btop
    config.boot.kernelPackages.nvidiaPackages.stable.bin
    fastfetch
    fzf
    ghostty
    git
    gparted
    ollama-cuda
    heroic
    kdePackages.dolphin
    lazygit
    libva-vdpau-driver
    libvdpau-va-gl
    mission-center
    mtpaint
    mysql-workbench
    mermaid-cli
    nil
    nix-tree
    nixpkgs-fmt
    ntfs3g
    nvidia-vaapi-driver # Helps with Nvidia video decoding
    obs-studio
    obsidian
    opencode
    claude-code
    protonplus
    refine
    spotify
    steam-run
    tmux
    tree
    vesktop
    vim
    vscode-fhs
    xwayland
    xwayland-satellite 
    zed-editor-fhs
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
  ];
}
