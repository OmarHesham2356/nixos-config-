{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];
  # Required home-manager state version
  home.stateVersion = "25.11";
  home.username = "omarnix";
  home.homeDirectory = "/home/omarnix";

  # ============================================================================
  # NEOVIM
  # ============================================================================
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    withRuby = false;

    extraPackages = with pkgs; [
      git
      gcc
      gnumake
      unzip
      wget
      ripgrep
      fd
      lua
      luarocks

      nodejs_22
      python3
      go
      cargo

      imagemagick
      ghostscript

      lua-language-server
      stylua
      nil
    ];
  };

  xdg.configFile."nvim" = {
    source = ./apps/nvim;
    recursive = true;
    force = true;
  };

  # ============================================================================
  # ZSH
  # ============================================================================
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

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
      }
    ];

    initContent = ''
      alias lg='lazygit'
      alias xv6='podman start -ai xv6-debian'

      # NixOS
      alias rebuild='nh os switch'
      alias update='cd ~/nixos && nix flake update && nh os switch'
      alias gc='nh clean all'
      alias nixlog='sudo nixos-rebuild switch --flake /etc/nixos#nixos --fallback 2>&1 | tail -20'
      alias nixsearch='nix-search-tv print | fzf --preview "nix-search-tv preview {}" --scheme history'
      alias nixedit='sudoedit /etc/nixos'

      # Git
      alias gs='git status'
      alias gp='git push'
      alias gl='git pull'
      alias gaa='git add -A'
      alias gcm='git commit -m'

      # Taskwarrior
      alias ta='task add'
      alias tl='task list'
      alias td='task done'
      alias tw='task wait:'
      alias tr='task modify'
      alias tx='task delete'
      alias tt='task summary'
      alias tp='task projects'

      # Quick access
      alias ..='cd ..'
      alias ...='cd ../..'
      alias ls='eza --icons'
      alias ll='eza -lah --icons --git'
      alias lt='eza -lah --icons --tree --level=2'
      alias ports='ss -tlnp'

      fastfetch

      # Zoxide (smarter cd)
      eval "$(zoxide init zsh)"

      # Pywal: source FZF colors if available
      [[ -f "$HOME/.cache/wal/fzf-default-opts" ]] && export FZF_DEFAULT_OPTS="$(cat "$HOME/.cache/wal/fzf-default-opts") --height=80% --layout=reverse"

      zstyle ':completion:*:git-checkout:*' sort false
      zstyle ':completion:*:descriptions' format '[%d]'
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
      zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --color=always --style=numbers --line-range=:500 $realpath'
      zstyle ':fzf-tab:*' switch-group '<' '>'
      zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
      zstyle ':fzf-tab:*' fzf-flags --height=80% --layout=reverse --border --margin=10%,20% --preview-window=right:50%

      # Taskwarrior zsh completion
      compdef _task ta tl td tw tr tx tt tp
      compdef _task task
    '';
  };

  programs.fzf = {
    enable = true;
    defaultOptions = [ "--border rounded" "--info inline" ];
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "pywal";
    };
  };

  # ============================================================================
  # NOCTALIA SHELL
  # ============================================================================
  programs.noctalia = {
    enable = true;
    settings = {
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };
      wallpaper = {
        enabled = true;
        default.path = "/home/omarnix/Pictures/wallpapers/default.jpg";
      };
    };
  };

  home.sessionVariables = {
    SHELL = "/run/current-system/profile/bin/zsh";
    GTK_THEME = "Adwaita-dark";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  # ============================================================================
  # HYPRLAND
  # ============================================================================
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    # System xdg.portal already provides KDE+GTK+hyprland portals (hosts/nixos/configuration.nix).
    # Home-manager's portal module otherwise exports NIX_XDG_DESKTOP_PORTAL_DIR to a profile dir
    # containing ONLY hyprland.portal, hiding the KDE/GTK portal defs and breaking ScreenCast.
    portalPackage = null;
    configType = "hyprlang";

    settings = {
      source = [ "~/.cache/wal/colors-hyprland.conf" ];
      env = [
        "XCURSOR_THEME, Bibata-Modern-Ice"
        "XCURSOR_SIZE, 24"
        "HYPRCURSOR_SIZE, 24"
        "GTK_THEME, Adwaita-dark"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba($color5cc) rgba($color4cc) rgba($color2cc)";
        "col.inactive_border" = "rgba($color800)";
        layout = "dwindle";
        hover_icon_on_border = true;
      };

      decoration = {
        rounding = 0;
        active_opacity = 0.92;
        inactive_opacity = 0.8;
        fullscreen_opacity = 1.0;

        blur = {
          enabled = true;
          size = 12;
          passes = 3;
          ignore_opacity = false;
          new_optimizations = true;
          xray = true;
          noise = "0.03";
          contrast = "0.65";
          brightness = "1.0";
          vibrancy = "0.35";
          vibrancy_darkness = "0.0";
        };

        shadow = {
          enabled = true;
          range = 20;
          render_power = 3;
          scale = 0.98;
          color = "rgba($color077)";
          offset = "0 4";
        };
      };

      animations = {
        enabled = true;

        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 0, 0, 1, 1"
        ];

        animation = [
          "windows, 1, 6, wind"
          "windowsIn, 1, 6, winIn"
          "windowsOut, 1, 6, winOut"
          "windowsMove, 1, 6, wind"
          "fade, 1, 6, liner"
          "fadeDim, 1, 6, liner"
          "border, 1, 6, liner"
          "borderangle, 1, 6, liner"
          "workspaces, 1, 6, wind"
        ];
      };

      input = {
        kb_layout = "us,ara";
        kb_options = "grp:alt_shift_toggle";
        follow_mouse = 1;
        sensitivity = 0;
        numlock_by_default = true;
        force_no_accel = false;
        float_switch_override_focus = 2;

        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          scroll_factor = 1.0;
        };
      };

      cursor = {
        no_hardware_cursors = true;
      };

      dwindle = {
        preserve_split = true;
        force_split = 2;
        special_scale_factor = 0.8;
        split_width_multiplier = 1.0;
        smart_split = false;
        smart_resizing = false;
        permanent_direction_override = true;
      };

      master = {
        special_scale_factor = 0.8;
        mfact = 0.55;
        orientation = "center";
        new_on_top = true;
        allow_small_split = true;
        drop_at_cursor = false;
      };

      misc = {
        disable_autoreload = false;
        enable_swallow = true;
        focus_on_activate = true;
        always_follow_on_dnd = true;
        animate_mouse_windowdragging = false;
        disable_splash_rendering = false;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = false;
        disable_hyprland_logo = true;
        vrr = 0;
      };

      binds = {
        allow_workspace_cycles = true;
        ignore_group_lock = false;
        workspace_back_and_forth = true;
        movefocus_cycles_fullscreen = false;
        scroll_event_delay = 300;
      };

      debug = {
        damage_blink = false;
        disable_logs = true;
        disable_time = false;
      };

      # Monitors — external DP-1 to the LEFT of laptop eDP-1
      monitor = [
        "DP-1, 1920x1080@120, -1920x0, 1"
        "eDP-1, 1920x1080@120, 0x0, 1"
        "HDMI-A-1, preferred, auto, 1"
        ", preferred, auto, 1"
      ];

      # Workspace rules — 1-5 on external (DP-1), 6-10 on laptop (eDP-1)
      workspace = [
        "1, monitor:DP-1, default:true"
        "2, monitor:DP-1"
        "3, monitor:DP-1"
        "4, monitor:DP-1"
        "5, monitor:DP-1"
        "6, monitor:eDP-1"
        "7, monitor:eDP-1"
        "8, monitor:eDP-1"
        "9, monitor:eDP-1"
        "10, monitor:eDP-1"
      ];

      # Keybindings
      bind = [
        # Core
        "SUPER, Q, exec, kitty"
        "SUPER, C, killactive"
        "SUPER, M, exit"
        "SUPER, E, exec, kitty -e yazi"
        "SUPER, F, fullscreen"
        "SUPER, P, pseudo"
        "SUPER, J, layoutmsg, togglesplit"

        # Apps
        "SUPER, Space, exec, noctalia msg panel-toggle launcher"
        "SUPER, L, exec, noctalia msg session lock"
        "SUPER, V, exec, noctalia msg panel-toggle clipboard"
        "SUPER SHIFT, A, exec, audio-switcher"
        "SUPER, A, exec, noctalia msg panel-toggle control-center"
        "SUPER, Tab, workspace, previous"
        "SUPER, S, exec, hyprshot -m region"
        "SUPER SHIFT, S, exec, hyprshot -m window"
        "SUPER, grave, exec, scratchpad"
        "SUPER, Print, exec, record-screen"
        "SUPER SHIFT, W, exec, web-search"
        "SUPER SHIFT, N, exec, kitty --class=nmtui -e nmtui"
        "SUPER SHIFT, O, exec, quick-notes"
        "SUPER, period, exec, noctalia msg panel-toggle launcher"
        "SUPER SHIFT, P, exec, hyprpicker -a"
        "ALT, Tab, exec, noctalia msg window-switcher"

        # Group
        "SUPER SHIFT, V, moveintogroup, l"
        "SUPER, N, togglegroup"
        "SUPER SHIFT, C, moveoutofgroup"

        # Focus
        "SUPER, left, movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up, movefocus, u"
        "SUPER, down, movefocus, d"

        # Swap
        "SUPER SHIFT, left, swapwindow, l"
        "SUPER SHIFT, right, swapwindow, r"
        "SUPER SHIFT, up, swapwindow, u"
        "SUPER SHIFT, down, swapwindow, d"

        # Workspaces
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"

        # Move to workspaces
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER SHIFT, 0, movetoworkspace, 10"
      ];

      # Mouse binds
      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

      # Locked binds (media keys)
      bindl = [
        ", XF86AudioRaiseVolume, exec, noctalia msg volume-up"
        ", XF86AudioLowerVolume, exec, noctalia msg volume-down"
        ", XF86AudioMute, exec, noctalia msg volume-mute"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86MonBrightnessUp, exec, noctalia msg brightness-up"
        ", XF86MonBrightnessDown, exec, noctalia msg brightness-down"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", Print, exec, hyprshot -m output"
        "SHIFT, Print, exec, hyprshot -m region"
        "CTRL, Print, exec, hyprshot -m window"
      ];

      # Window rules
      windowrule = [
        "workspace 5 on, match:class ^(vesktop)$"
        "workspace 3 on, match:class ^(obsidian)$"
        "float on, match:class ^(copyq)$"
        "float on, match:class ^(pavucontrol)$"
        "float on, match:class ^(blueman-manager)$"
        "float on, match:class ^(org.gnome.Calculator)$"
        "float on, match:class ^(org.gnome.Nautilus)$"
        "float on, match:class ^(thunar)$"
        "float on, match:class ^(imv)$"
        "float on, match:class ^(mpv)$"
        "workspace 2 on, match:title ^(.* — Mozilla Firefox)$"
        "workspace 2 on, match:title ^(zen-beta — Zen Browser)$"
        "float on, pin on, match:title ^(picture in picture)$"
        "workspace special:scratchpad on, float on, match:class ^(scratchpad)$"
        "float on, match:class ^(notes)$"
        "float on, match:class ^(nmtui)$"
        "float on, size 1080 920, match:class ^(dev.noctalia.Noctalia)$"
      ];

      # Layer rules
      layerrule = [
        "no_anim on, match:namespace ^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$"
        "ignore_alpha 0.5, match:namespace ^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$"
        "blur on, match:namespace ^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$"
        "order 9999, match:namespace copyq"
      ];

      # Autostart
      exec-once = [
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "noctalia"
        "wl-paste --watch cliphist store"
        "blueman-applet"
        "swaync"
      ];
    };
  };

  # ============================================================================
  # KITTY
  # ============================================================================
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    settings = {
      background_opacity = "0.85";
      background_blur = 12;
      window_padding_width = 8;
      window_margin_width = 4;
      window_border_width = "2px";
      hide_window_decorations = "no";
      cursor_shape = "block";
      cursor_beam_thickness = 2.0;
      cursor_blink_interval = 0.5;
      cursor_stop_blinking_after = 15.0;
      cursor_trail = 3;
      cursor_trail_decay = "0.1 0.9";
      shell_integration = "enabled";
      scrollback_lines = 10000;
      enable_audio_bell = "no";
      confirm_os_window_close = 0;
      remember_window_size = "no";
      initial_window_width = 1200;
      initial_window_height = 800;
      tab_bar_style = "powerline";
      tab_bar_edge = "top";
      tab_bar_margin_width = 0.0;
      tab_bar_margin_height = "0.0 0.0";
      "map ctrl+shift+c" = "copy_to_clipboard";
      "map ctrl+shift+v" = "paste_from_clipboard";
      "map ctrl+shift+equal" = "change_font_size all +2.0";
      "map ctrl+shift+minus" = "change_font_size all -2.0";
      "map ctrl+shift+backslash" = "change_font_size all 0.0";
      include = "${config.xdg.configHome}/kitty/colors-kitty.conf";
    };
  };

  # ============================================================================
  # ZED EDITOR
  # ============================================================================
  programs.zed-editor = {
    enable = true;
    userSettings = {
      theme = {
        mode = "dark";
        light = "One Dark";
        dark = "Pywal";
      };
      cursor_blink = true;
    };
  };

  # ============================================================================
  # YAZI
  # ============================================================================
  programs.yazi = {
    enable = true;
    shellWrapperName = "yy";
  };

  # ============================================================================
  # TMUX
  # ============================================================================
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    keyMode = "vi";
    extraConfig = ''
      set -g @plugin 'tmux-plugins/tpm'
      set -g @plugin 'tmux-plugins/tmux-sensible'
      set -g @plugin 'tmux-plugins/tmux-resurrect'
      set -g @plugin 'tmux-plugins/tmux-yank'

      set -g @resurrect-capture-pane-contents 'on'
      set -g @resurrect-strategy-nvim 'session'
      set -g @resurrect-processes '"opencode" "lazygit"'

      set -g mouse on
      source-file ~/.config/tmux/theme.conf
      run '~/.tmux/plugins/tpm/tpm'
    '';
  };

  xdg.configFile."scripts/tmux-reload.sh" = {
    text = ''
      #!/bin/sh
      tmux source-file ~/.config/tmux/theme.conf 2>/dev/null || true
    '';
    executable = true;
  };

  # swaync should only run inside Hyprland (started via Hyprland exec-once), NOT in KDE Plasma.
  # Otherwise it grabs org.freedesktop.Notifications and breaks KDE's notification service.
  # Override the packaged systemd unit so it never auto-starts via graphical-session.target.
  systemd.user.services.swaync = {
    Unit = {
      Description = "swaync (only started from Hyprland)";
      PartOf = "hyprland-session.target";
    };
    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "/run/current-system/sw/bin/true";
    };
    Install.WantedBy = [ ];
  };

  xdg.configFile."systemd/user/tmux-theme-watcher.path".text = ''
    [Unit]
    Description=Watch tmux theme for changes

    [Path]
    PathModified=${config.home.homeDirectory}/.config/tmux/theme.conf
    Unit=tmux-reload.service

    [Install]
    WantedBy=default.target
  '';

  xdg.configFile."systemd/user/tmux-reload.service".text = ''
    [Unit]
    Description=Reload tmux config

    [Service]
    Type=oneshot
    ExecStart=${config.home.homeDirectory}/.config/scripts/tmux-reload.sh
  '';

  # ============================================================================
  # GTK
  # ============================================================================
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk4.theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    font = {
      name = "Noto Sans";
      size = 10;
    };
    gtk3.extraConfig = {
      "gtk-application-prefer-dark-theme" = true;
      "gtk-cursor-theme-name" = "Bibata-Modern-Ice";
      "gtk-cursor-theme-size" = 24;
    };
    gtk4.extraConfig = {
      "gtk-application-prefer-dark-theme" = true;
      "gtk-cursor-theme-name" = "Bibata-Modern-Ice";
      "gtk-cursor-theme-size" = 24;
    };

  };

  # ============================================================================
  # FONTS
  # ============================================================================
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" ];
      sansSerif = [ "JetBrainsMono Nerd Font" "Noto Sans Arabic" ];
      serif = [ "JetBrainsMono Nerd Font" "Noto Naskh Arabic" ];
    };
  };

  # ============================================================================
  # HOME PACKAGES
  # ============================================================================
  home.packages = with pkgs; [
    # Scripts (converted from fish to bash)
    (writeShellScriptBin "audio-switcher" (builtins.readFile ./scripts/audio-switcher))
    (writeShellScriptBin "bluetooth-status" (builtins.readFile ./scripts/bluetooth-status))
    (writeShellScriptBin "bluetooth-toggle" (builtins.readFile ./scripts/bluetooth-toggle))
    (writeShellScriptBin "caffeine-status" (builtins.readFile ./scripts/caffeine-status))
    (writeShellScriptBin "caffeine-toggle" (builtins.readFile ./scripts/caffeine-toggle))
    (writeShellScriptBin "clipboard" (builtins.readFile ./scripts/clipboard))
    (writeShellScriptBin "kb-layout" (builtins.readFile ./scripts/kb-layout))
    (writeShellScriptBin "powermenu" (builtins.readFile ./scripts/powermenu))
    (writeShellScriptBin "power-save-status" (builtins.readFile ./scripts/power-save-status))
    (writeShellScriptBin "power-save-toggle" (builtins.readFile ./scripts/power-save-toggle))
    (writeShellScriptBin "quick-notes" (builtins.readFile ./scripts/quick-notes))
    (writeShellScriptBin "record-screen" (builtins.readFile ./scripts/record-screen))
    (writeShellScriptBin "scratchpad" (builtins.readFile ./scripts/scratchpad))
    (writeShellScriptBin "wallpaper" (builtins.readFile ./scripts/wallpaper))
    (writeShellScriptBin "tmux-theme-gen" (builtins.readFile ./scripts/tmux-theme-gen))
    (writeShellScriptBin "web-search" (builtins.readFile ./scripts/web-search))
    (writeShellScriptBin "wifi-status" (builtins.readFile ./scripts/wifi-status))
    (writeShellScriptBin "wifi-toggle" (builtins.readFile ./scripts/wifi-toggle))

    # wal wrapper: shadows system wal so every invocation runs the pywal-hook
    # colorthief backend works without imagemagick
    (let
      walPython = pkgs.python3.withPackages (ps: with ps; [ pywal16 colorthief ]);
    in pkgs.writeShellScriptBin "wal" ''
      ${walPython}/bin/wal --backend colorthief "$@"
      WAL_EXIT=$?
      HOOK="$HOME/.config/wal/scripts/pywal-hook"
      [ -x "$HOOK" ] && "$HOOK" 2>/dev/null || true
      exit $WAL_EXIT
    '')
  ];

  # ============================================================================
  # PYWAL PLACEHOLDER (create if missing so waybar/kitty don't crash)
  # ============================================================================
  home.activation.pywalPlaceholder = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "$HOME/.cache/wal"
    mkdir -p "$HOME/.config/btop/themes"
    mkdir -p "$HOME/.config/yazi"

    # Force dark color scheme for GTK/libadwaita apps (pavucontrol, etc.)
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null || true

    # === waybar CSS ===
    if [ ! -f "$HOME/.cache/wal/colors-waybar.css" ]; then
      cat > "$HOME/.cache/wal/colors-waybar.css" << 'CSSEOF'
@define-color foreground #cdd6f4;
@define-color background #1e1e2e;
@define-color cursor #f5e0dc;
@define-color color0 #1e1e2e;
@define-color color1 #f38ba8;
@define-color color2 #a6e3a1;
@define-color color3 #f9e2af;
@define-color color4 #89b4fa;
@define-color color5 #f5c2e7;
@define-color color6 #94e2d5;
@define-color color7 #bac2de;
@define-color color8 #585b70;
@define-color color9 #f38ba8;
@define-color color10 #a6e3a1;
@define-color color11 #f9e2af;
@define-color color12 #89b4fa;
@define-color color13 #f5c2e7;
@define-color color14 #94e2d5;
@define-color color15 #a6adc8;
CSSEOF
    fi

    # === hyprland colors ===
    if [ ! -f "$HOME/.cache/wal/colors-hyprland.conf" ]; then
      cat > "$HOME/.cache/wal/colors-hyprland.conf" << 'HYPREOF'
$wallpaper = /home/omarnix/Pictures/wallpapers/default.jpg
$background = #1e1e2e
$foreground = #cdd6f4
$color0 = #1e1e2e
$color1 = #f38ba8
$color2 = #a6e3a1
$color3 = #f9e2af
$color4 = #89b4fa
$color5 = #f5c2e7
$color6 = #94e2d5
$color7 = #bac2de
$color8 = #585b70
$color9 = #f38ba8
$color10 = #a6e3a1
$color11 = #f9e2af
$color12 = #89b4fa
$color13 = #f5c2e7
$color14 = #94e2d5
$color15 = #a6adc8
$color5cc = f5c2e7cc
$color4cc = 89b4facc
$color2cc = a6e3a1cc
$color800 = 585b7000
$color077 = 1e1e2e77
HYPREOF
    fi

    # === GTK CSS ===
    if [ ! -f "$HOME/.cache/wal/colors-gtk.css" ]; then
      cat > "$HOME/.cache/wal/colors-gtk.css" << 'CSSEOF'
:root {
  --bg-color: #1e1e2e;
  --fg-color: #cdd6f4;
  --selected-bg: #89b4fa;
  --selected-fg: #1e1e2e;
  --error-color: #f38ba8;
  --success-color: #a6e3a1;
  --warning-color: #f9e2af;
  --info-color: #89b4fa;
  --link-color: #f5c2e7;
  --insensitive-bg: #585b70;
  --insensitive-fg: #bac2de;
}
headerbar, .titlebar { background-color: #1e1e2e; color: #cdd6f4; }
*:selected, :selected { background-color: #89b4fa; color: #1e1e2e; }
a { color: #f5c2e7; }
button { color: #cdd6f4; }
scrollbar slider { background-color: #585b70; }
switch:checked { background-color: #89b4fa; }
CSSEOF
    fi

    # === hyprlock colors ===
    if [ ! -f "$HOME/.cache/wal/colors-hyprlock.conf" ]; then
      cat > "$HOME/.cache/wal/colors-hyprlock.conf" << 'HYPREOF'
$bg = rgb(30, 30, 46)
$bga = rgba(30, 30, 46, 0.8)
$fg = rgb(205, 214, 244)
$fga = rgba(205, 214, 244, 0.8)
$c0 = rgb(30, 30, 46)
$c1 = rgb(243, 139, 168)
$c2 = rgb(166, 227, 161)
$c3 = rgb(249, 226, 175)
$c4 = rgb(137, 180, 250)
$c5 = rgb(245, 194, 231)
$c6 = rgb(148, 226, 213)
$c7 = rgb(186, 194, 222)
$c8 = rgb(88, 91, 112)
$c9 = rgb(243, 139, 168)
$c10 = rgb(166, 227, 161)
$c11 = rgb(249, 226, 175)
$c12 = rgb(137, 180, 250)
$c13 = rgb(245, 194, 231)
$c14 = rgb(148, 226, 213)
$c15 = rgb(166, 173, 200)
HYPREOF
    fi

    # === kitty colors ===
    if [ ! -f "$HOME/.cache/wal/colors-kitty.conf" ]; then
      cat > "$HOME/.cache/wal/colors-kitty.conf" << 'KITTYEOF'
foreground              #cdd6f4
background              #1e1e2e
selection_foreground    #1e1e2e
selection_background    #cdd6f4
cursor                  #f5e0dc
cursor_text_color       #1e1e2e
url_color               #f5e0dc
active_tab_foreground   #89b4fa
active_tab_background   #1e1e2e
inactive_tab_foreground #585b70
inactive_tab_background #1e1e2e
mark1_foreground        #1e1e2e
mark1_background        #89b4fa
mark2_foreground        #1e1e2e
mark2_background        #89b4fa
mark3_foreground        #1e1e2e
mark3_background        #a6e3a1
color0  #1e1e2e
color8  #585b70
color1  #f38ba8
color9  #f38ba8
color2  #a6e3a1
color10 #a6e3a1
color3  #f9e2af
color11 #f9e2af
color4  #89b4fa
color12 #89b4fa
color5  #f5c2e7
color13 #f5c2e7
color6  #94e2d5
color14 #94e2d5
color7  #bac2de
color15 #a6adc8
KITTYEOF
    fi

    # === btop theme symlink ===
    rm -f "$HOME/.config/btop/themes/pywal.theme"
    ln -sf "$HOME/.cache/wal/colors-btop.theme" "$HOME/.config/btop/themes/pywal.theme"

    # === yazi theme symlink ===
    rm -f "$HOME/.config/yazi/theme.toml"
    ln -sf "$HOME/.cache/wal/colors-yazi.toml" "$HOME/.config/yazi/theme.toml"
  '';

  # ============================================================================
  # XDG CONFIG FILES
  # ============================================================================
  xdg.configFile = {
    # Btop
    "btop" = {
      source = ./apps/btop;
      recursive = true;
      force = true;
    };

    # Cava
    "cava" = {
      source = ./apps/cava;
      recursive = true;
    };

    # Yazi extra configs (mkForce to override module-generated files)
    "yazi/yazi.toml".source = lib.mkForce ./apps/yazi/yazi.toml;
    "yazi/keymap.toml".source = lib.mkForce ./apps/yazi/keymap.toml;

    # Fastfetch config — tree layout with Nerd Font icons
    "fastfetch/config.jsonc" = {
      force = true;
      text = ''
        {
          "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/master/doc/json_schema.json",
          "logo": {
            "type": "small",
            "padding": { "top": 1, "left": 1, "right": 1 }
          },
          "display": {
            "separator": " ",
            "percent": { "type": 3, "color": { "green": 30, "yellow": 60 } },
            "bar": { "width": 15, "char": { "elapsed": "█", "total": "░" } }
          },
          "modules": [
            {
              "type": "custom",
              "format": "{#green}  󰌢 System{#}",
              "outputColor": "green"
            },
            {
              "type": "os",
              "key": "{#green}├─{icon}{#}",
              "keyColor": "green",
              "format": "{name} {version}"
            },
            {
              "type": "host",
              "key": "{#green}├─󰌢{#}",
              "keyColor": "green"
            },
            {
              "type": "kernel",
              "key": "{#green}├─{icon}{#}",
              "keyColor": "green"
            },
            {
              "type": "uptime",
              "key": "{#green}├─󰅐{#}",
              "keyColor": "green"
            },
            {
              "type": "packages",
              "key": "{#green}╰─󰏖{#}",
              "keyColor": "green"
            },
            "break",
            {
              "type": "custom",
              "format": "{#blue}  󰍛 Hardware{#}",
              "outputColor": "blue"
            },
            {
              "type": "cpu",
              "key": "{#blue}├─󰻠{#}",
              "keyColor": "blue",
              "format": "{name} ({cores-physical}C/{cores-logical}T)"
            },
            {
              "type": "gpu",
              "key": "{#blue}├─󰍛{#}",
              "keyColor": "blue"
            },
            {
              "type": "memory",
              "key": "{#blue}├─󰑭{#}",
              "keyColor": "blue",
              "format": "{used} / {total} {percentage-bar}"
            },
            {
              "type": "disk",
              "key": "{#blue}├─{icon}{#}",
              "keyColor": "blue",
              "format": "{size-used} / {size-total} [{size-percentage}]",
              "folders": "/"
            },
            {
              "type": "battery",
              "key": "{#blue}╰─{icon}{#}",
              "keyColor": "blue",
              "format": "{capacity} {capacity-bar}"
            },
            "break",
            {
              "type": "custom",
              "format": "{#yellow}   Desktop{#}",
              "outputColor": "yellow"
            },
            {
              "type": "wm",
              "key": "{#yellow}├─{icon}{#}",
              "keyColor": "yellow"
            },
            {
              "type": "terminal",
              "key": "{#yellow}├─{icon}{#}",
              "keyColor": "yellow"
            },
            {
              "type": "shell",
              "key": "{#yellow}╰─{icon}{#}",
              "keyColor": "yellow"
            },
            "break",
            {
              "type": "custom",
              "format": "{#magenta}   Tasks{#}",
              "outputColor": "magenta"
            },
            {
              "type": "command",
              "key": "{#magenta}╰─{#}",
              "keyColor": "magenta",
              "text": "count=$(task status:pending count 2>/dev/null); if [ \"$count\" -gt 0 ]; then echo \"$count pending\"; task rc.verbose:blank limit:3 status:pending 2>/dev/null | tail -n +2 | sed 's/^/    /'; else echo \"none pending\"; fi"
            }
          ]
        }
      '';
    };

    # Pywal templates
    "wal/templates/colors-hyprland.conf".source = ./apps/wal/templates/colors-hyprland.conf;
    "wal/templates/colors-hyprlock-vars.conf".source = ./apps/wal/templates/colors-hyprlock-vars.conf;
    "wal/templates/colors.lua".source = ./apps/wal/templates/colors.lua;
    "wal/templates/colors-nvim.lua".source = ./apps/wal/templates/colors-nvim.lua;
    "wal/templates/colors-btop.theme".source = ./apps/wal/templates/colors-btop.theme;
    "wal/templates/colors-cava.conf".source = ./apps/wal/templates/colors-cava.conf;
    "wal/templates/colors-yazi.toml".source = ./apps/wal/templates/colors-yazi.toml;
    "wal/templates/colors-gtk.css".source = ./apps/wal/templates/colors-gtk.css;
    "wal/templates/colors-kitty.conf".source = ./apps/wal/templates/colors-kitty.conf;

    # Pywal hook script (called by wal wrapper after every invocation)
    "wal/scripts/pywal-hook" = {
      source = ./scripts/pywal-hook;
      executable = true;
    };

    # Fontconfig
    "fontconfig/fonts.conf".source = ./apps/fontconfig/fonts.conf;
    "fontconfig/conf.d/60-arabic-fallback.conf".source = ./apps/fontconfig/conf.d/60-arabic-fallback.conf;

    # Zed editor pywal theme (generated by pywal-hook)
    "zed/themes/pywal.json".source = lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.cache/wal/zed.json");

    # OpenCode pywal theme config
    "opencode/tui.json".source = ./apps/opencode/tui.json;
  };
}
