# hosts/zorin/service/jellyfin-nginx.nix
#
# Jellyfin (rootful Podman, matches virtualization.nix default) fronted
# by nginx + Let's Encrypt, reachable directly at vars.ddnsHost now that
# 190.32.71.11 is confirmed to be a real, unshared, inbound-reachable
# public IP (no CGNAT). Replaces the old DigitalOcean WireGuard relay
# for this purpose.
#
# Requires (outside this file):
#   - Router port-forward: WAN 80  -> <LAN IP of this host>:80  (TCP)
#   - Router port-forward: WAN 443 -> <LAN IP of this host>:443 (TCP)
#   - Router's built-in No-IP DDNS client keeping vars.ddnsHost current
#   - Ports 80/443 already allowed in modules/networking.nix
#
# Fill in the ACME email below before first deploy.

{ config, pkgs, vars, ... }:

{
  virtualisation.oci-containers.containers.jellyfin = {
    image = "jellyfin/jellyfin:10.10.7";  # pinned: 10.11.x has a known regression
    autoStart = true;

    ports = [
      "127.0.0.1:8096:8096"  # loopback-only; nginx is the only thing that talks to it
    ];

    volumes = [
      "jellyfin_config:/config"
      "jellyfin_cache:/cache"
      # Add your media library mounts here, e.g.:
      # "/mnt/media:/media:ro"
    ];
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "danzorinnewhorizon@gmail.com"; # <-- set your own email here
  };

  services.nginx = {
    enable = true;

    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    virtualHosts.${vars.ddnsHost} = {
      forceSSL = true;
      enableACME = true;

      locations."/" = {
        proxyPass = "http://127.0.0.1:8096";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_buffering off;
          proxy_send_timeout 100m;
          proxy_read_timeout 100m;

          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };
  };
}
