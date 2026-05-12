#!/bin/zsh
# Apply matugen colors to prompt and syntax highlighting
# This file is sourced after colors.zsh

if [[ -n "$COLOR_PRIMARY" ]]; then
  # Override strug theme prompt with matugen colors
  PROMPT="%F{$COLOR_PRIMARY}╭─%n@%m %F{$COLOR_ON_SURFACE}in %~ %f${git_branch}
%F{$COLOR_PRIMARY}╰\$ %f"

  # Override syntax-highlighting to use matugen colors
  if command -v ZSH_HIGHLIGHT_STYLES &>/dev/null; then
    ZSH_HIGHLIGHT_STYLES[command]="fg=$COLOR_PRIMARY,bold"
    ZSH_HIGHLIGHT_STYLES[alias]="fg=$COLOR_PRIMARY,bold"
    ZSH_HIGHLIGHT_STYLES[builtin]="fg=$COLOR_PRIMARY,bold"
    ZSH_HIGHLIGHT_STYLES[function]="fg=$COLOR_PRIMARY,bold"
    ZSH_HIGHLIGHT_STYLES[precommand]="fg=$COLOR_PRIMARY,bold"
    ZSH_HIGHLIGHT_STYLES[hashed-command]="fg=$COLOR_PRIMARY,bold"
    ZSH_HIGHLIGHT_STYLES[path]="fg=$COLOR_ON_SURFACE,underline"
    ZSH_HIGHLIGHT_STYLES[file]="fg=$COLOR_ON_SURFACE"
    ZSH_HIGHLIGHT_STYLES[dir]="fg=$COLOR_SURFACE,bold"
  fi
fi
