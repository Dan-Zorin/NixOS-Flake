{ config, pkgs, ... }:

{
virtualisation.podman = {
    enable = true;
    dockerCompat = false;
    defaultNetwork.settings.dns_enabled = true;
    };

security.unprivilegedUsernsClone = true;


  # //Waydroid support for app development
  virtualisation.waydroid.enable = true;
  networking.nftables.enable = true;
  networking.firewall.enable = true;

environment.systemPackages = with pkgs; [
    waydroid
    podman-compose
  ];

}
