{ config, pkgs, ... }:

{
  # 1. Printing — Canon G3020 via AirPrint/IPP (driverless)
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
    ];
  };

  # Configure Canon G3020 with everywhere URI and set as default
  systemd.services.cups-setup-printer = {
    description = "Configure Canon G3020 printer with Everywhere";
    after = [ "cups.service" ];
    wantedBy = [ "cups.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "setup-printer" ''
        for i in $(seq 1 10); do
          ${pkgs.cups}/bin/lpstat -r 2>/dev/null && break
          sleep 1
        done

        ${pkgs.cups}/bin/lpadmin -x Canon_G3020_series 2>/dev/null || true

        # Use the 'everywhere' driver to let CUPS negotiate driverless profiles
        ${pkgs.cups}/bin/lpadmin \
          -p Canon_G3020_series \
          -v "ipp://192.168.30.40/ipp/print" \
          -E \
          -m "everywhere" \
          -o printer-is-shared=false

        ${pkgs.cups}/bin/lpoptions -d Canon_G3020_series
      '';
    };
  };

  # Auto-discover printers/scanners on the network
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # 2. Scanning — Canon G3020 supports eSCL/AirScan
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
    openFirewall = true;
  };

  # Enable saned — network scanning daemon that desktop apps rely on
  services.saned.enable = true;

  # Force sane-airscan to use HTTP and specify the exact Canon G3020 IP
  environment.etc."sane-config/airscan.conf" = {
    text = ''
      [devices]
      Canon_G3020_Scanner = http://192.168.30.40:80/eSCL/, escl
    '';
  };

  # Make sure your main user can scan
  users.users.omarnix.extraGroups = [ "scanner" "lp" ];
}
