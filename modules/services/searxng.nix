{ config, pkgs, ... }:

{
  services.searx = {
    enable = true;
    package = pkgs.searxng;
    settings = {
      server = {
        port = 8082;
        bind_address = "127.0.0.1";
        secret_key = "f74a95126dac4ad65a0bc34123c007bf8d9b7e82b327a3f102a93d0536919bb5";
      };
      search.formats = [ "html" "json" ];
      engines = [
        { name = "google"; engine = "google"; shortcut = "go"; }
        { name = "duckduckgo"; engine = "duckduckgo"; shortcut = "ddg"; }
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [ 8082 ];
}
