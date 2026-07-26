{ config, pkgs, ... }:

{
  # Enable KDE Connect
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
}