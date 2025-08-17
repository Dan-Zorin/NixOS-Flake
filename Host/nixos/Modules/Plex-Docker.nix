{ config, pkgs, lib, ... }:

{
  systemd.services."plex-docker" = {
    description = "Plex Media Server (Docker Compose)";
    after = [ "docker.service" "network.target" ];
    requires = [ "docker.service" ];

    serviceConfig = {
      WorkingDirectory = "/etc/nixos/docker/plex";
      ExecStart = "${pkgs.docker}/bin/docker compose up";
      ExecStop = "${pkgs.docker}/bin/docker compose down";
      Restart = "always";
    };

    wantedBy = [ "multi-user.target" ];
  };
}
