{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.portainerBE;
in

{
  options.services.portainerBE = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Portainer Business Edition Docker container.";
    };

    image = mkOption {
      type = types.str;
      default = "portainer/portainer-ee:latest";
      description = "Docker image for Portainer BE.";
    };

    licenseKey = mkOption {
      type = types.str;
      default = "";
      description = "Portainer BE license key (required).";
    };

    ports = mkOption {
      type = types.listOf types.str;
      default = [ "9000:9000" ];
      description = "Port mappings for Portainer BE.";
    };

    dataDir = mkOption {
      type = types.str;
      default = "/srv/portainerBE/data";
      description = "Directory to persist Portainer BE data.";
    };
  };

  config = mkIf cfg.enable {
    # The module does NOT enable Docker automatically.
    # User must do:
    # virtualisation.docker.enable = true;

    # Define a systemd service to run the Docker container
    systemd.services.portainerBE = {
      description = "Portainer Business Edition";
      wants = [ "docker.service" ];
      after = [ "docker.service" ];
      serviceConfig = {
        Restart = "always";
        ExecStart = ''
          /run/current-system/sw/bin/docker run \
            --name portainerBE \
            -p ${lib.concatStringsSep " -p " cfg.ports} \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -v ${cfg.dataDir}:/data \
            -e PORTAINER_EDITION=business \
            -e LICENSE_KEY=${cfg.licenseKey} \
            ${cfg.image}
        '';
        ExecStop = "/run/current-system/sw/bin/docker stop portainerBE || true";
        ExecStopPost = "/run/current-system/sw/bin/docker rm portainerBE || true";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
