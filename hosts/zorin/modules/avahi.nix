{ config, pkgs, ... }:

{
  # Avahi mDNS/DNS-SD (for .local hostnames and service discovery)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;

    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };

  # Clean up stale PID on boot
  systemd.tmpfiles.rules = [
    "r /run/avahi-daemon/pid - - - -"
  ];
}