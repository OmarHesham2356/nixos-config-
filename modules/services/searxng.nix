{ config, pkgs, ... }:

let
  secretKey = builtins.readFile ../../secrets/searxng-secret-key.txt;
in
{
  services.searx = {
    enable = true;
    package = pkgs.searxng;
    settings = {
      server = {
        port = 8082;
        bind_address = "127.0.0.1";
        secret_key = secretKey;
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
