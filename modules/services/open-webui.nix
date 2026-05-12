{ config, pkgs, ... }:

{
  services.open-webui = {
    enable = true;
    port = 8081;
  };
}
