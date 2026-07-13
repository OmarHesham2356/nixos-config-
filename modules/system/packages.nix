{ config, pkgs, pi-mono, ... }:

{
  environment.systemPackages = with pkgs; [
    pi-mono.packages.${pkgs.system}.default
    docker-compose
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
    nvidia-vaapi-driver
    obs-studio
    obsidian
    opencode
    claude-code
    protonplus
    refine
    spotify
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
    anki
    mediainfo
    nixd
    ouch
    vnstat
    steam-run
    tmux
    tree
    vesktop
    vim
    vscode-fhs
    nodejs_22
    zed-editor-fhs
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    p7zip
    unrar

    # Hyprland ecosystem
    hyprshot
    hyprpicker
    hyprlock
    hypridle
    waybar
    swaynotificationcenter
    rofi
    rofi-emoji
    kitty
    cliphist
    wl-clipboard
    brightnessctl
    playerctl
    pavucontrol
    imv
    wlogout
    awww
    libnotify

    # Pywal
    python3Packages.pywal

    # Minecraft
    hmcl

    # Fonts
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji

    # Cursor themes
    bibata-cursors
  ];
}
