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
    nix-search-tv
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
    (kdePackages.skanlite.overrideAttrs (oldAttrs: {
      postInstall = (oldAttrs.postInstall or "") + ''
        mkdir -p $out/share/applications
        substituteInPlace $out/share/applications/org.kde.skanlite.desktop \
          --replace-fail "Exec=skanlite" "Exec=env SANE_CONFIG_DIR=/etc/sane-config LD_LIBRARY_PATH=/etc/sane-libs skanlite"
      '';
    }))
    vnstat
    nh
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

    # Media
    mpv
    yt-dlp
    imagemagick

    # Graphics
    gimp

    # Documents
    zathura

    # File managers
    xfce.thunar
    xfce.thunar-volman

    # System tools
    lm_sensors
    gpu-screen-recorder
    zoxide
    eza

    # Polkit agent for privilege escalation prompts
    polkit_gnome

    # Wine
    wineWow64Packages.stable
    winetricks

    # MangoHud (overlay for gamescope)
    mangohud

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
    taskwarrior3
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
