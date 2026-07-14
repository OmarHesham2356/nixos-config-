{ config, pkgs, lib, ... }:

let
  # Generate a deterministic secret from hostname + service name
  # For a local-only service (127.0.0.1), this is sufficient for CSRF protection
  secretKey = builtins.hashString "sha256" "searxng-${config.networking.hostName}-csrf-key";
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
