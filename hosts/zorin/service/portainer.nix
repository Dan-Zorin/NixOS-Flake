# hosts/zorin/service/portainer.nix
#
# Portainer CE, rootful (matches virtualisation.podman default set in
# modules/virtualization.nix — no need to redeclare rootful/dockerCompat
# here).
#
# LAN-only by design. Not proxied through nginx, not port-forwarded on
# the router. Reachable at http://<lan-ip>:9000 from inside the network.
#
# Casual/temporary — safe to delete this file + its import line in
# configuration.nix if you stop needing it. Named volume persists until
# manually pruned: `sudo podman volume rm portainer_data`.

{ config, pkgs, vars, ... }:

{
  virtualisation.oci-containers.containers.portainer = {
    image = "portainer/portainer-ce:latest";
    autoStart = true;

    ports = [
      "9000:9000"  # HTTP UI
      "9443:9443"  # HTTPS UI (self-signed, fine for LAN-only use)
    ];

    volumes = [
      "/run/podman/podman.sock:/var/run/docker.sock:ro"
      "portainer_data:/data"
    ];
  };

  # LAN-only: intentionally NOT forwarded on the router. Add 9000/9443
  # to networking.firewall in networking.nix only if you want it
  # reachable from other devices on the LAN (it's bound to all
  # interfaces by podman's port mapping either way, so the NixOS
  # firewall is your actual gate here).
  networking.firewall.allowedTCPPorts = [ 9000 9443 ];
}
