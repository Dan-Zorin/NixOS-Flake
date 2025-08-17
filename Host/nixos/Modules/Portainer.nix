# modules/portainer-be-gpu.nix
{ config, pkgs, lib, ... }:

with lib;

let
  nvidiaRuntime = "${pkgs.nvidia-container-toolkit}/bin/nvidia-container-runtime";
in
{
  options.portainerBE = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Portainer Business Edition with GPU support.";
    };
    licenseKey = mkOption {
      type = types.str;
      default = "";
    };
    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/portainer";
    };
    ports = mkOption {
      type = types.listOf types.int;
      default = [9000 9443 8000];
    };
  };

  config = mkIf config.portainerBE.enable {
    # Install NVIDIA container toolkit
    environment.systemPackages = [ pkgs.nvidia-container-toolkit ];

    # Enable Docker
    virtualisation.docker.enable = true;

    # Configure daemon.json so containerd sees the NVIDIA runtime
    environment.etc."docker/daemon.json".text = ''
      {
        "runtimes": {
          "nvidia": {
            "path": "${nvidiaRuntime}",
            "runtimeArgs": []
          }
        }
      }
    '';

    # Systemd service for Portainer BE
    systemd.services.portainerBE = {
      description = "Portainer Business Edition with GPU support";
      after = [ "docker.service" ];
      wants = [ "docker.service" ];
      serviceConfig.Type = "simple";
      serviceConfig.ExecStart = ''
        ${pkgs.docker}/bin/docker run \
          --rm \
          --name portainerBE \
          --gpus all \
          -p ${lib.concatStringsSep " -p " (map toString config.portainerBE.ports)} \
          -v /var/run/docker.sock:/var/run/docker.sock \
          -v ${config.portainerBE.dataDir}:/data \
          -e PORTAINER_EDITION=business \
          -e LICENSE_KEY=${config.portainerBE.licenseKey} \
          portainer/portainer-ee:latest
      '';
      serviceConfig.Restart = "always";
    };
  };
}

