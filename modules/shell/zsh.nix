{ config, pkgs, ... }:

{
  # Make Zsh available and set it as the default shell for your user
  programs.zsh.enable = true;
  users.users.omarnix.shell = pkgs.zsh;

  # Oh My Zsh + external plugins
  programs.zsh.ohMyZsh = {
    enable = true;
    theme = "strug";                  # your chosen theme
    plugins = [
      "git"          # built‑in oh‑my‑zsh plugin
      "z"            # built‑in "z" directory jumper
      "sudo"         # double‑tap Esc to add sudo
      # The following three are *external* plugins – we add them below
    ];
  };

  # External Zsh plugins (not part of Oh My Zsh)
  programs.zsh.plugins = [
    {
      name = "zsh-autosuggestions";
      src = pkgs.zsh-autosuggestions;
    }
    {
      name = "zsh-syntax-highlighting";
      src = pkgs.zsh-syntax-highlighting;
    }
    {
      name = "fzf-tab";
      src = pkgs.fzf-tab;
    }
  ];

  # Enable fzf (required for fzf‑tab)
  programs.fzf.enable = true;

  # Aliases, environment variables, and zstyle commands
  programs.zsh.interactiveShellInit = ''
    # Aliases (from your config)
    alias lg='lazygit'

    # Export PATH additions
    export PATH="$HOME/.local/bin:$PATH"
    export PATH="$HOME/.opencode/bin:$PATH"   # adjust path if needed

    # Fastfetch at login (run once)
    fastfetch

    # ---- zstyle settings (completion, fzf‑tab previews) ----
    # Disable sort when completing `git checkout`
    zstyle ':completion:*:git-checkout:*' sort false
    # Set descriptions format to enable group support
    zstyle ':completion:*:descriptions' format '[%d]'

    # Preview directory content with eza (you may need to install eza)
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
    # Preview file content using bat (install bat if desired)
    zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --color=always --style=numbers --line-range=:500 $realpath'
    # Switch group using < and >
    zstyle ':fzf-tab:*' switch-group '<' '>'
    # Use tmux popup for fzf-tab (requires tmux)
    zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
    # "Fake Popup" configuration
    zstyle ':fzf-tab:*' fzf-flags --height=80% --layout=reverse --border --margin=10%,20% --preview-window=right:50%
  '';
}
