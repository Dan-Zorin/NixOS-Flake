{ config, pkgs, ... }:

{
  # Network Manager for easy WiFi/Ethernet management
  networking.networkmanager.enable = true;

  # Hostname is set in main configuration.nix
  # networking.hostName = "zorin";

  # Enable firewall
  networking.firewall = {
    enable = true;
     allowedTCPPorts = [ 80 443 22 37365 2222 50000 50050 50020 25565 ];
     allowedUDPPorts = [ 37365 50010 50020 ];

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
  # Moved to avahi.nix

  # Optional: OpenSSH
   services.openssh = {
     enable = true;
     settings = {
       PasswordAuthentication = false;
       PermitRootLogin = "no";
     };
   };
}