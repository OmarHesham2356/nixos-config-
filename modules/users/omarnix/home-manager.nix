{
  pkgs,
  lib,
  dms,
  inputs,
  ...
}:

{
  # Import DMS home-manager modules
  imports = [
    dms.homeModules.dank-material-shell
  ];

  # Required home-manager state version
  home.stateVersion = "25.11";

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Essential system dependencies for LazyVim/Telescope
    extraPackages = with pkgs; [
      # 1. Neovim Core Requirements
      git
      gcc
      gnumake
      unzip
      wget
      ripgrep
      fd
      lua
      luarocks

      # 2. Language Runtimes (for Mason/LSPs)
      nodejs_22
      python3
      python3Packages.pip
      go
      cargo

      # 3. Media & Image Support (for snacks.nvim)
      imagemagick
      ghostscript

      # 4. LSPs & Formatters
      lua-language-server
      stylua
      nil # Nix Language Server
    ];
  };

  # Link your local LazyVim config files to the standard Neovim config path
  xdg.configFile."nvim" = {
    source = ./nvim; # Point this to your nvim config folder
    recursive = true;
  };

  # Zsh shell configuration
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "strug";
      plugins = [
        "git"
        "z"
        "sudo"
      ];
    };

    # Correct way to handle common plugins in Home Manager
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
      }
    ];

    # CHANGED: Use initExtra instead of interactiveShellInit
    initExtra = ''
      alias lg='lazygit'
      export PATH="$HOME/.local/bin:$PATH"
      export PATH="$HOME/.opencode/bin:$PATH"
      fastfetch

      zstyle ':completion:*:git-checkout:*' sort false
      zstyle ':completion:*:descriptions' format '[%d]'
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
      zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --color=always --style=numbers --line-range=:500 $realpath'
      zstyle ':fzf-tab:*' switch-group '<' '>'
      zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
      zstyle ':fzf-tab:*' fzf-flags --height=80% --layout=reverse --border --margin=10%,20% --preview-window=right:50%
    '';
  };

  # Enable fzf for fzf-tab
  programs.fzf.enable = true;

  # Home manager settings
  home.sessionVariables = {
    SHELL = "/run/current-system/profile/bin/zsh";
  };

  # DankMaterialShell configuration
  programs.dank-material-shell = {
    enable = true;
    enableSystemMonitoring = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableClipboardPaste = true;
    systemd = {
      enable = true;
      restartIfChanged = true;
    };
  };
}
