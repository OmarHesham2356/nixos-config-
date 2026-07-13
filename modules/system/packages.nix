{ config, pkgs, pi-mono, ... }:

{
  environment.systemPackages = with pkgs; [
    pi-mono.packages.${pkgs.system}.default
    prismlauncher
    docker-compose
    python313
    onlyoffice-desktopeditors
    baobab
    bat
    btop
    # nvidia driver is configured in nvidia.nix (production package)
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

    # Minecraft (cracked/offline — PrismLauncher-Cracked)
    # prismlauncher-cracked.packages.${pkgs.system}.default

    # Cursor themes
    bibata-cursors
  ];

  # Fonts — must use fonts.packages for fontconfig registration
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];
}
