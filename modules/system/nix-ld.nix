{ config, pkgs, ... }:

{
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    zstd
    stdenv.cc.cc.lib

    libxshmfence
    libx11
    libxext
    libxdamage
    libxfixes
    libxcomposite
    libxrandr
    libxkbfile
    libXcursor
    libXinerama
    libxscrnsaver
    libXi
    libXtst
    libxcb

    nss
    nspr
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    dbus
    expat
    libdrm
    libxkbcommon
    mesa
    pango
    cairo
  ];
}
