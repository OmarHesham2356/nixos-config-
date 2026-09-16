{ config, pkgs, ... }:

{
  services.mongodb = {
    enable = true;
    # mongodb-ce ships precompiled binaries; the default `mongodb` package
    # builds from source on every update.
    package = pkgs.mongodb-ce;
  };
}