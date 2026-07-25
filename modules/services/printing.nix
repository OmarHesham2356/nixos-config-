{ config, pkgs, ... }:

{
  # Printing — Canon PIXMA G3420 (AirPrint + cnijfilter2 driver)
  services.printing = {
    enable = true;
    drivers = [ pkgs.cnijfilter2 ];
  };

  # Auto-discover printers/scanners on the network via Avahi/mDNS
  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };

  # Scanning — Canon PIXMA G3420 supports eSCL/AirScan
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
    disabledDefaultBackends = [ "escl" ]; # airscan supersedes escl
  };
}
