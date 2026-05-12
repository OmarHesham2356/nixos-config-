{ config, pkgs, ... }:

{
  services.flatpak.enable = true;
  services.fwupd.enable = true;
}
