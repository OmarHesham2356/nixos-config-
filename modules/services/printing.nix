{ config, pkgs, ... }:

{
  # Printing — Canon PIXMA G3420 (AirPrint + cnijfilter2 driver)
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cnijfilter2
      cups-filters
      cups-browsed
    ];
  };

  # Auto-discover printers/scanners on the network via Avahi/mDNS
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Scanning — Canon PIXMA G3420 supports eSCL/AirScan
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
    # Don't disable escl — let both airscan and escl work
  };
}
