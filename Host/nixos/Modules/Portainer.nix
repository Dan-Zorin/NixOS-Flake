{ config, pkgs, lib, ... }:

let
  cfg = config.services.portainer;
in {
  options.services.portainer = {
    enable = lib.mkEnableOption "Portainer Business Edition";
    licenseKey = lib.mkOption {
      type = lib.types.str;
      description = "Portainer Business license key";
    };
    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/portainer";
      description = "Storage path for Portainer data";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker.enable = true;

    virtualisation.oci-containers.containers.portainer = {
      image = "portainer/portainer-ee:latest";
      environment = {
        PORTAINER_LICENSE_KEY = cfg.licenseKey;
      };
      volumes = [
        "${cfg.dataDir}:/data"
        "/var/run/docker.sock:/var/run/docker.sock"
      ];
      ports = [
        "9000:9000"
        "8000:8000"  # Edge agent port
      ];
      extraOptions = [ "--pull=always" ];
    };

    systemd.services.portainer-setup = {
      description = "Portainer initialization";
      wantedBy = [ "portainer.service" ];
      before = [ "portainer.service" ];
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p ${cfg.dataDir}
        chmod 700 ${cfg.dataDir}
      '';
    };

    networking.firewall.allowedTCPPorts = [ 9000 8000 ];
  };
}
