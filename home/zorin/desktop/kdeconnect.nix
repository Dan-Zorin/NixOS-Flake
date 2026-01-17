{ config, pkgs, ... }:

{
  # Enable KDE Connect
  services.kdeconnect = {
    enable = true;
    indicator = true;  # Show indicator in system tray
  };

  # KDE Connect requires these ports to be open
  # This will be handled at system level, see below
}