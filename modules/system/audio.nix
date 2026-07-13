{ config, pkgs, ... }:

let
  alsa-fix = pkgs.writeShellScript "alsa-fix" ''
    # Wait for PipeWire to be ready
    sleep 2
    # Fix Dell G15 SOF ALSA mixer defaults
    ${pkgs.alsa-utils}/bin/amixer -c 1 set 'Headphone' 87 unmute 2>/dev/null || true
    ${pkgs.alsa-utils}/bin/amixer -c 1 set 'Speaker' 87 unmute 2>/dev/null || true
    ${pkgs.alsa-utils}/bin/amixer -c 1 set 'Master' 87 unmute 2>/dev/null || true
  '';
in
{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.pulseaudio.enable = false;

  # Fix Dell SOF ALSA mixer defaults (Speaker 0%, Headphone muted)
  systemd.user.services.alsa-fix = {
    description = "Fix ALSA mixer defaults for Dell SOF";
    wantedBy = [ "graphical-session.target" ];
    after = [ "pipewire.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${alsa-fix}";
    };
  };
}
