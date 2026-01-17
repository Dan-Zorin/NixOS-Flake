{ config, pkgs, ... }:

{
  # Network Manager for easy WiFi/Ethernet management
  networking.networkmanager.enable = true;

  # Hostname is set in main configuration.nix
  # networking.hostName = "zorin";

  # Enable firewall
  networking.firewall = {
    enable = true;
    # allowedTCPPorts = [ 80 443 22 ];
    # allowedUDPPorts = [ ];

    # KDE Connect ports
    allowedTCPPortRanges = [
      { from = 1714; to = 1764; }  # KDE Connect
    ];
    allowedUDPPortRanges = [
      { from = 1714; to = 1764; }  # KDE Connect
    ];
  };

  # Optional: disable wait-online service (faster boot)
  systemd.services.NetworkManager-wait-online.enable = false;

  # Optional: Enable mDNS (for .local hostnames)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };

  # Optional: OpenSSH
   services.openssh = {
     enable = true;
     settings = {
       PasswordAuthentication = false;
       PermitRootLogin = "no";
     };
   };
}