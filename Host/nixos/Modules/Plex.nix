{ config, pkgs, ... }:

{
  services.plex = {
    enable = true;
    openFirewall = true;
    dataDir = "/var/lib/plex";
    extraMounts = [
      {
        hostPath = "/media/HDD/Movies";
        containerPath = "/media/HDD/Movies";
      }
      {
        hostPath = "/media/HDD/TV Shows";
        containerPath = "/media/HDD/TV Shows";
      }
    ];
  };

  # Ensure Plex has access permissions
  users.users.plex.extraGroups = [ "users" ];
}
