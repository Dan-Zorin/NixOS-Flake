{ config, pkgs, ... }:
{
  programs.kdeconnect = {
    enable = true;
    package = pkgs.kdePackages.kdeconnect-kde;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  networking.firewall.allowedTCPPorts = [ 1714 1764 ];
  networking.firewall.allowedUDPPorts = [ 1714 1764 ];
}

