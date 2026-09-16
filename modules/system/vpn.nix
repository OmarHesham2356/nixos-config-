{ config, pkgs, lib, ... }:

let
  cfg = config.services.protonvpn-wg;
in
{
  options.services.protonvpn-wg = {
    enable = lib.mkEnableOption "ProtonVPN WireGuard tunnel (wg-quick)";

    interface = lib.mkOption {
      type = lib.types.str;
      default = "proton0";
      description = ''
        Name of the WireGuard interface. wg-quick reads its config from
        /etc/wireguard/<interface>.conf, so drop Proton's config here.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # wg-quick needs these helpers on PATH to bring the tunnel up
    systemd.services.protonvpn-wg = {
      description = "ProtonVPN WireGuard tunnel (wg-quick)";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [ iproute2 wireguard-tools iptables nftables openresolv coreutils ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.wireguard-tools}/bin/wg-quick up ${cfg.interface}";
        ExecStop = "${pkgs.wireguard-tools}/bin/wg-quick down ${cfg.interface}";
      };
    };
  };
}