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

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  services.blueman.enable = true;

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

  # Enable AppImage support with binfmt_misc
  # This registers AppImage files as executable by the kernel
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  users.users.omarnix = {
    isNormalUser = true;
    description = "omarnix";
    extraGroups = [
      "networkmanager"
      "wheel"
      "podman"
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
    package = config.boot.kernelPackages.nvidiaPackages.production;
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

  programs.yazi = {
  enable = true;
  };

  # fwupd
  services.fwupd.enable = true;

  # Niri compositor
  programs.niri.enable = true;

  # Ensure Xwayland is supported
  programs.xwayland.enable = true;

#nix-ld for better performance with Nvidia drivers
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # The basics
    zstd
    stdenv.cc.cc.lib
    
    # X11/GUI libraries
    libxshmfence
    libx11
    libxext
    libxdamage
    libxfixes
    libxcomposite
    libxrandr
    libxkbfile
    libXcursor
    libXinerama
    libxscrnsaver
    libXi
    libXtst
    libxcb
    
    # WebEngine/Browser stuff
    nss
    nspr
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    dbus
    expat
    libdrm
    libxkbcommon
    mesa
    pango
    cairo
  ];

  # Podman (drop-in Docker replacement)
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Docker (disabled - using Podman instead)
  # virtualisation.docker.enable = true;


  
  services.searx = {
    enable = true;
    package = pkgs.searxng;
    settings = {
      server = {
        port = 8082;
        bind_address = "127.0.0.1";
        secret_key = "f74a95126dac4ad65a0bc34123c007bf8d9b7e82b327a3f102a93d0536919bb5";
      };
      search.formats = [ "html" "json" ];
      engines = [
        { name = "google"; engine = "google"; shortcut = "go"; }
        { name = "duckduckgo"; engine = "duckduckgo"; shortcut = "ddg"; }
      ];
    };
  };



  networking.firewall.allowedTCPPorts = [ 8082 ];

  services.open-webui = {
    enable = true;
    port = 8081; # You can choose any port
  };

    
  # System packages
  environment.systemPackages = with pkgs; [
    python313 
    python313Packages.pip
    onlyoffice-desktopeditors
    baobab
    bat
    btop
    config.boot.kernelPackages.nvidiaPackages.stable.bin
    fastfetch
    fzf
    gh
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
    swayidle
    qwen-code
    github-copilot-cli
    qbittorrent
    gearlever
    (appimage-run.override {
      extraPkgs = pkgs: with pkgs; [
        pkgs.zstd
        pkgs.nss
        pkgs.nspr
        pkgs.libxshmfence
        pkgs.libXdamage
        pkgs.libdrm
        pkgs.mesa
        pkgs.alsa-lib
        pkgs.at-spi2-atk
        pkgs.atk
        pkgs.dbus
        pkgs.expat
      ];
    })
    vnstat
    steam-run
    tmux
    tree
    vesktop
    vim
    vscode-fhs
    nodejs_22
    xwayland
    xwayland-satellite 
    zed-editor-fhs
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    p7zip
  ];
}
