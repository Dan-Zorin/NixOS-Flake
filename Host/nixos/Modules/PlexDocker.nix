{ config, pkgs, lib, ... }:

let
  dockerDir = "/etc/nixos/docker/jellyfin";
in
{
  # Write docker-compose.yml declaratively
  environment.etc."nixos/docker/jellyfin/docker-compose.yml".text = ''
    version: "3.9"
    services:
      jellyfin:
        image: jellyfin/jellyfin:latest
        container_name: jellyfinDocker
        network_mode: host
        environment:
          - PUID=1000
          - PGID=100
        volumes:
          - /var/lib/jellyfin:/config
          - /media/HDD/Movies:/movies
          - /media/HDD/TVShows:/tv
        restart: unless-stopped
  '';

  # Systemd unit to run docker compose
  systemd.services."jellyfin-docker" = {
    description = "Jellyfin Media Server (Docker Compose)";
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

  # Ensure Docker is available
  environment.systemPackages = [ pkgs.docker pkgs.docker-compose pkgs.nvidia-container-toolkit ];
  virtualisation.docker.enable = true;
}

