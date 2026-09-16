{ config, pkgs, ... }:

{
  services.redis.servers = {
    # Default instance: listens on 127.0.0.1:6379, no auth (local dev use)
    "" = {
      enable = true;
    };
  };
}