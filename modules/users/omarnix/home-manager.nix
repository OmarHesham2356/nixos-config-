{
  pkgs,
  lib,
  dms,
  inputs,
  config,
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
      # Source matugen colors if available
      [[ -f ~/.config/zsh/colors.zsh ]] && source ~/.config/zsh/colors.zsh

      # Apply matugen colors to prompt and syntax highlighting
      [[ -f ~/.config/zsh/zsh-matugen-colors.zsh ]] && source ~/.config/zsh/zsh-matugen-colors.zsh

      alias lg='lazygit'
      alias xv6='podman start -ai xv6-debian'
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

  # Yazi file manager configuration with zip compression shortcut
  programs.yazi = {
    enable = true;
    keymap = {
      manager.prepend_keymap = [
        {
          on = [ "c" "z" ];
          run = ''shell 'zip -r "$@.zip" "$@"' --block --confirm'';
          desc = "Zip selected files";
        }
      ];
    };
  };

  # Matugen template for tmux theming
  xdg.configFile."matugen/templates/tmux-colors.conf" = {
    source = ./templates/tmux-colors.conf;
  };

  # Matugen template for zsh theming
  xdg.configFile."matugen/templates/zsh-colors.zsh" = {
    source = ./templates/zsh-colors.zsh;
  };

  # Script to apply matugen colors to prompt and syntax highlighting
  xdg.configFile."zsh/zsh-matugen-colors.zsh" = {
    source = ./scripts/zsh-matugen-colors.zsh;
  };

  # Matugen config to use the tmux and zsh templates
  xdg.configFile."matugen/config.toml".text = ''
    [config]

    [templates.tmux-theme]
    input_path = '${config.home.homeDirectory}/.config/matugen/templates/tmux-colors.conf'
    output_path = '${config.home.homeDirectory}/.config/tmux/theme.conf'

    [templates.zsh-theme]
    input_path = '${config.home.homeDirectory}/.config/matugen/templates/zsh-colors.zsh'
    output_path = '${config.home.homeDirectory}/.config/zsh/colors.zsh'
  '';

  # Tmux configuration with matugen theming and tpm plugin manager
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    keyMode = "vi";
    extraConfig = ''
      # List of plugins
      set -g @plugin 'tmux-plugins/tpm'
      set -g @plugin 'tmux-plugins/tmux-sensible'
      set -g @plugin 'tmux-plugins/tmux-resurrect'
      set -g @plugin 'tmux-plugins/tmux-yank'
      
      # tmux-resurrect configuration
      set -g @resurrect-capture-pane-contents 'on'
      set -g @resurrect-strategy-nvim 'session'
      set -g @resurrect-processes '"opencode" "lazygit"'
      
      set -g mouse on
      # Source matugen theme
      source-file ~/.config/tmux/theme.conf
      # Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
      run '~/.tmux/plugins/tpm/tpm'
    '';
  };

  # Script to reload tmux config
  xdg.configFile."scripts/tmux-reload.sh" = {
    text = ''
      #!/bin/sh
      tmux source-file ~/.config/tmux/theme.conf 2>/dev/null || true
    '';
    executable = true;
  };

  # Manually create systemd path unit (watch for theme.conf changes)
  xdg.configFile."systemd/user/tmux-theme-watcher.path".text = ''
    [Unit]
    Description=Watch tmux theme for changes

    [Path]
    PathModified=${config.home.homeDirectory}/.config/tmux/theme.conf
    Unit=tmux-reload.service

    [Install]
    WantedBy=default.target
  '';

  # Manually create systemd service (reload tmux)
  xdg.configFile."systemd/user/tmux-reload.service".text = ''
    [Unit]
    Description=Reload tmux config

    [Service]
    Type=oneshot
    ExecStart=${config.home.homeDirectory}/.config/scripts/tmux-reload.sh
  '';
}
