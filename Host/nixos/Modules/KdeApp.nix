{
  programs.kdeconnect = {
    enable = true;
    package = pkgs.kdePackages.kdeconnect-kde;
  };

  # Optional: enable network discovery support (needed for pairing)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Open KDE Connect ports in the firewall
  networking.firewall.allowedTCPPorts = [ 1714 1764 ];
  networking.firewall.allowedUDPPorts = [ 1714 1764 ];
}
