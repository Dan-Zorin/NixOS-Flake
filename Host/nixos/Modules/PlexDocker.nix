{ config, pkgs, lib, ... }:

let
  dockerDir = "/etc/nixos/docker/plex";
in
{
  # Write docker-compose.yml declaratively
  environment.etc."nixos/docker/plex/docker-compose.yml".text = ''
    version: "3.9"
    services:
      plex:
        image: lscr.io/linuxserver/plex:latest
        container_name: plex
        network_mode: host
        environment:
          - PUID=1000
          - PGID=100
          - VERSION=docker
        volumes:
          - /var/lib/plex:/config
          - /media/HDD/Movies:/movies
          - /media/HDD/TVShows:/tv
        restart: unless-stopped
  '';

  # Systemd unit to run docker compose
  systemd.services."plex-docker" = {
    description = "Plex Media Server (Docker Compose)";
    after = [ "docker.service" "network.target" ];
    requires = [ "docker.service" ];

    serviceConfig = {
      WorkingDirectory = dockerDir;
      ExecStart = "${pkgs.docker}/bin/docker compose up";
      ExecStop = "${pkgs.docker}/bin/docker compose down";
      Restart = "always";
    };

    wantedBy = [ "multi-user.target" ];
  };
}
