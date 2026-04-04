{ config, pkgs, ... }:

{
  # Make Zsh available and set it as the default shell for your user
  programs.zsh.enable = true;
  users.users.omarnix.shell = pkgs.zsh;

  # Oh My Zsh + external plugins
  programs.zsh.ohMyZsh = {
    enable = true;
    theme = "strug";
    plugins = [
      "git"
      "z"
      "sudo"
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
      src = pkgs.zsh-fzf-tab;      # corrected package name
      file = "fzf-tab.zsh";        # main file
    }
  ];

  # Aliases, environment variables, and zstyle commands
  programs.zsh.interactiveShellInit = ''
    alias lg='lazygit'
    export PATH="$HOME/.local/bin:$PATH"
    export PATH="$HOME/.opencode/bin:$PATH"
    fastfetch

    # zstyle settings
    zstyle ':completion:*:git-checkout:*' sort false
    zstyle ':completion:*:descriptions' format '[%d]'
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
    zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --color=always --style=numbers --line-range=:500 $realpath'
    zstyle ':fzf-tab:*' switch-group '<' '>'
    zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
    zstyle ':fzf-tab:*' fzf-flags --height=80% --layout=reverse --border --margin=10%,20% --preview-window=right:50%
  '';
}
