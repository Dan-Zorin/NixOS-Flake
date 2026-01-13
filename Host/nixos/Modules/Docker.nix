{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    rootless.enable = false;
  };

  users.extraGroups.docker.members = [ "zorin" ];

  environment.systemPackages = with pkgs; [
    docker-compose
    waydroid
  ];


  # Enable Waydroid
  virtualisation.waydroid.enable = true;

    networking.nftables.enable = true;
  networking.firewall.enable = true;

}
