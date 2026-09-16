{ config, pkgs, pi-mono, ... }:

{
  environment.systemPackages = with pkgs; [
    #pi-mono.packages.${pkgs.system}.default
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
    #ollama-cuda
    heroic
    nautilus
    lazygit
    libva-vdpau-driver
    libvdpau-va-gl
    mission-center
    mtpaint
    #mysql-workbench
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
    (simple-scan.overrideAttrs (oldAttrs: {
      postInstall = (oldAttrs.postInstall or "") + ''
        mkdir -p $out/share/applications
        substituteInPlace $out/share/applications/org.gnome.SimpleScan.desktop \
          --replace-fail "Exec=simple-scan" "Exec=env SANE_CONFIG_DIR=/etc/sane-config LD_LIBRARY_PATH=/etc/sane-libs simple-scan"
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
    zed-editor-fhs
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    p7zip
    unrar
    typst

    proton-vpn
    wireguard-tools

    # RiseupVPN — free unlimited no-account VPN, obfs4 anti-DPI transport.
    # Launch as: riseup-vpn --obfs4
    riseup-vpn

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
    brave
    # Pywal
    python3Packages.pywal

    # Minecraft (cracked/offline — PrismLauncher-Cracked)
    # prismlauncher-cracked.packages.${pkgs.system}.default

    # Cursor themes
    bibata-cursors

    # Kvantum — Qt theming engine (kvantummanager GUI + engine)
    kdePackages.qtstyleplugin-kvantum

    # VPN/Proxy (warp-plus + tun2socks are installed by modules/system/warp-plus.nix)
    sing-box
    v2ray

    # YubiKey tools
    yubikey-manager
    yubioath-flutter
    pam_u2f

    # MongoDB Compass — GUI (mongosh moved to devshell flake)
    mongodb-compass

    # Postman — API testing
    postman

    # Vulkan diagnostics (vulkaninfo) — drivers themselves ship with NVIDIA/mesa
    vulkan-tools
    vulkan-validation-layers

    # .NET SDK — C# development (MongoDB/ASP.NET apps)
    dotnet-sdk
  ];

  # Fonts — must use fonts.packages for fontconfig registration
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];
}
