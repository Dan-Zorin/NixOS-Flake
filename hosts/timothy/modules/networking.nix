{ config, pkgs, ... }:

{
  # Network Manager for easy WiFi/Ethernet management
  networking.networkmanager.enable = true;

  # Hostname is set in main configuration.nix

  # Enable firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];

    # KDE Connect ports
    allowedTCPPortRanges = [
      { from = 1714; to = 1764; }
    ];
    allowedUDPPortRanges = [
      { from = 1714; to = 1764; }
    ];
  };

  # NOTE: zorin's networking.nix opens a bunch of extra ports
  # (37365, 2222, 50000/50050/50020, 25565, etc.) for self-hosted services
  # that timothy doesn't run. Add specific ports back here if timothy ends
  # up hosting something.

  # Optional: disable wait-online service (faster boot)
  systemd.services.NetworkManager-wait-online.enable = false;

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}
