{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:

{
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
      fastfetch

      # Pywal: source FZF colors if available
      [[ -f "$HOME/.cache/wal/fzf-default-opts" ]] && export FZF_DEFAULT_OPTS="$(cat "$HOME/.cache/wal/fzf-default-opts") --height=80% --layout=reverse"

      zstyle ':completion:*:git-checkout:*' sort false
      zstyle ':completion:*:descriptions' format '[%d]'
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
      zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --color=always --style=numbers --line-range=:500 $realpath'
      zstyle ':fzf-tab:*' switch-group '<' '>'
      zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
      zstyle ':fzf-tab:*' fzf-flags --height=80% --layout=reverse --border --margin=10%,20% --preview-window=right:50%
    '';
  };

  programs.fzf = {
    enable = true;
    defaultOptions = [ "--border rounded" "--info inline" ];
  };

  programs.bat = {
    enable = true;
    # No theme set — inherits pywal colors from terminal
  };

  home.sessionVariables = {
    SHELL = "/run/current-system/profile/bin/zsh";
    GTK_THEME = "adw-gtk3-dark";
  };

  # ============================================================================
  # HYPRLAND
  # ============================================================================
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    configType = "hyprlang";

    settings = {
      source = [ "~/.cache/wal/colors-hyprland.conf" ];
      env = [
        "XCURSOR_THEME, Bibata-Modern-Ice"
        "XCURSOR_SIZE, 24"
        "HYPRCURSOR_SIZE, 24"
        "GTK_THEME, adw-gtk3-dark"
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
        "SUPER, Space, togglefloating"
        "SUPER, P, pseudo"
        "SUPER, J, layoutmsg, togglesplit"

        # Apps
        "SUPER, R, exec, rofi -show drun"
        "SUPER SHIFT, R, exec, rofi -show run"
        "SUPER, L, exec, hyprlock"
        "SUPER, V, exec, clipboard"
        "SUPER SHIFT, A, exec, audio-switcher"
        "SUPER, A, exec, swaync-client -t"
        "SUPER, Tab, workspace, previous"
        "SUPER, S, exec, hyprshot -m region"
        "SUPER SHIFT, S, exec, hyprshot -m window"
        "SUPER, B, exec, systemctl --user restart waybar"
        "SUPER, grave, exec, scratchpad"
        "SUPER, Print, exec, record-screen"
        "SUPER SHIFT, W, exec, web-search"
        "SUPER SHIFT, N, exec, kitty --class=nmtui -e nmtui"
        "SUPER SHIFT, O, exec, quick-notes"
        "SUPER, period, exec, rofi -show emoji"
        "SUPER SHIFT, P, exec, hyprpicker -a"

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
      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];

      bindl = [
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
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
      ];

      # Layer rules
      layerrule = [
        "no_anim on, match:namespace waybar"
        "blur on, match:namespace waybar"
        "blur on, match:namespace swaync-control-center"
        "ignore_alpha 0, match:namespace swaync-control-center"
        "blur on, match:namespace swaync-notification-window"
        "ignore_alpha 0, match:namespace swaync-notification-window"
        "order 9999, match:namespace copyq"
      ];

      # Autostart
      exec-once = [
        "awww-daemon"
        "swaync"
        "wl-paste --watch cliphist store"
        "hypridle"
        "blueman-applet"
      ];
    };
  };

  # ============================================================================
  # WAYBAR
  # ============================================================================
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 28;
        spacing = 4;

        modules-left = [ "hyprland/workspaces" "mpris" "cava" ];
        modules-center = [ "clock" ];
        modules-right = [ "custom/cpu" "custom/memory" "pulseaudio" "backlight" "hyprland/language" "network" "battery" "power-profiles-daemon" "tray" "custom/power" ];

        "hyprland/workspaces" = {
          format = "{icon}";
          move-to-monitor = true;
          on-click = "activate";
          sort-by-number = true;
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "10";
            "urgent" = "!";
          };
          persistent-workspaces = {
            "DP-1" = [ 1 2 3 4 5 ];
            "eDP-1" = [ 6 7 8 9 10 ];
          };
        };

        "mpris" = {
          format = "{player_icon} {dynamic}";
          "format-paused" = "{status_icon} <i>{dynamic}</i>";
          status-icons = { paused = "⏸"; };
          player-icons = { default = "▶"; };
          "artist-len" = 15;
          "title-len" = 25;
          "album-len" = 12;
          "dynamic-len" = 35;
          on-click = "playerctl play-pause";
          "on-click-right" = "playerctl next";
          "on-click-middle" = "playerctl previous";
        };

        cava = {
          "cava_config" = "${config.home.homeDirectory}/.config/cava/waybar.conf";
          "input_delay" = 2;
          "format-icons" = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
          actions = {
            "on-click-middle" = "mode";
          };
        };

        clock = {
          format = "{:%I:%M %p}";
          "format-alt" = "{:%a %b %d}";
          "tooltip-format" = "{:%A, %B %d, %Y}";
          interval = 30;
          calendar = {
            format = {
              today = "<span color='@color4'><b><u>{}</u></b></span>";
            };
          };
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          "format-muted" = "{icon} M";
          "format-icons" = {
            default = [ "󰕿" "󰖀" "󰕾" ];
          };
          on-click = "pavucontrol";
          "scroll-step" = 5;
        };

        network = {
          "format-wifi" = "󰤨 {signalStrength}%";
          "format-ethernet" = "󰤨";
          "format-disconnected" = "󰤭";
          "tooltip-format" = "{ifname} via {gwaddr}";
          interval = 30;
        };

        battery = {
          states = {
            warning = 20;
            critical = 10;
          };
          format = "{icon} {capacity}%";
          "format-charging" = "󰂃 {capacity}%";
          "format-plugged" = "󰂃 {capacity}%";
          "format-icons" = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" ];
          "tooltip-format" = "{timeTo} {power}";
        };

        "hyprland/language" = {
          format = "{}";
          "format-en" = "US";
          "format-ar" = "AR";
          "on-click" = "hyprctl switchxkblayout 0 next";
        };

        backlight = {
          format = "☀ {percent}%";
          "scroll-step" = 5;
          "on-scroll-up" = "brightnessctl set 5%+";
          "on-scroll-down" = "brightnessctl set 5%-";
        };

        "custom/cpu" = {
          format = "󰍛 {}%";
          tooltip = false;
          interval = 5;
          exec = "grep '^cpu ' /proc/stat | awk '{print int((\\$2+\\$4)*100/(\\$2+\\$4+\\$5))}'";
          "exec-if" = "true";
        };

        "custom/memory" = {
          format = "󰀽 {}%";
          tooltip = false;
          interval = 10;
          exec = "free | awk '/^Mem/ {printf \"%.0f\", \\$3/\\$2 * 100}'";
          "exec-if" = "true";
        };

        "power-profiles-daemon" = {
          format = "{icon}";
          "tooltip-format" = "{profile}";
          "format-icons" = {
            default = "󰂚";
            performance = "󰓅";
            balanced = "󰂎";
            "power-saver" = "󰌪";
          };
        };

        tray = {
          "icon-size" = 16;
          spacing = 4;
        };

        "custom/power" = {
          format = "⏻";
          on-click = "powermenu";
          tooltip = false;
        };
      };
    };
    style = builtins.readFile ./apps/waybar/style.css;
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
  # ROFI
  # ============================================================================
  programs.rofi = {
    enable = true;
    cycle = true;
    terminal = "kitty";
    theme = "pywal";
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
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    gtk4.theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
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
    gtk3.extraCss = ''
      @import url("file://${config.xdg.cacheHome}/wal/colors-gtk.css");
    '';
    gtk4.extraCss = ''
      @import url("file://${config.xdg.cacheHome}/wal/colors-gtk.css");
    '';
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
    # for correct hyprland/kitty color generation with alpha variants
    (pkgs.writeShellScriptBin "wal" ''
      ${pkgs.python3Packages.pywal}/bin/wal "$@"
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
$color5cc = f5c2e7,0.8
$color4cc = 89b4fa,0.8
$color2cc = a6e3a1,0.8
$color800 = 585b70,0.0
$color077 = 1e1e2e,0.467
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

    # === rofi colors symlink ===
    rm -f "$HOME/.config/rofi/colors-rofi.rasi"
    ln -sf "$HOME/.cache/wal/colors-rofi.rasi" "$HOME/.config/rofi/colors-rofi.rasi"
  '';

  # ============================================================================
  # XDG CONFIG FILES
  # ============================================================================
  xdg.configFile = {
    # Waybar config (JSONC - symlink raw file)
    "waybar/config.jsonc".source = ./apps/waybar/config.jsonc;

    # SwayNC
    "swaync/config.json".source = ./apps/swaync/config.json;
    "swaync/style.css".source = ./apps/swaync/style.css;

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

    # Pywal templates
    "wal/templates/colors-hyprland.conf".source = ./apps/wal/templates/colors-hyprland.conf;
    "wal/templates/colors-hyprlock-vars.conf".source = ./apps/wal/templates/colors-hyprlock-vars.conf;
    "wal/templates/colors.lua".source = ./apps/wal/templates/colors.lua;
    "wal/templates/colors-nvim.lua".source = ./apps/wal/templates/colors-nvim.lua;
    "wal/templates/colors-rofi.rasi".source = ./apps/wal/templates/colors-rofi.rasi;
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

    # Hyprland configs
    "hypr/hypridle.conf".source = ./apps/hypr/hypridle.conf;
    "hypr/hyprlock.conf".source = ./apps/hypr/hyprlock.conf;

    # Rofi colors (symlinked to pywal output by activation + wallpaper script)
    "rofi/colors-rofi.rasi".source = lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.cache/wal/colors-rofi.rasi");

    # Rofi pywal theme
    "rofi/pywal.rasi".source = ./apps/rofi/pywal.rasi;

    # Zed editor pywal theme (generated by pywal-hook)
    "zed/themes/pywal.json".source = lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.cache/wal/zed.json");
  };
}
