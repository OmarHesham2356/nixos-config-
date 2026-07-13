{ config, pkgs, ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };
  services.blueman.enable = true;

  # Polkit rule so users in wheel group can manage bluetooth
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if ((action.id.indexOf("org.bluez.") == 0 ||
           action.id.indexOf("org.blueman.") == 0) &&
          subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

  # WirePlumber Bluetooth A2DP config
  services.pipewire.wireplumber.configPackages = [
    (pkgs.writeTextDir "wireplumber/wireplumber.conf.d/51-bluetooth-a2dp.conf" ''
      monitor.bluez.rules = [
        {
          matches = [
            {
              device.name = "~bluez_card.*"
            }
          ]
          actions = {
            update-props = {
              bluez5.auto-connect = true
              bluez5.hfphsp-backend = "none"
              bluez5.a2dp.ldac.quality = "auto"
              bluez5.a2dp.sbc.max-bitrate = 0
              bluez5.codecs = "aac,sbc"
            }
          }
        }
      ]
    '')
  ];
}
