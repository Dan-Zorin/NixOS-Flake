# modules/docker-nvidia.nix
{ config, lib, pkgs, ... }:

with lib;

let
  nvidiaRuntimePath = "${pkgs.nvidia-container-toolkit}/bin/nvidia-container-runtime";
in
{
  options.dockerNvidia = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable NVIDIA GPU support for Docker.";
    };
  };

  config = mkIf config.dockerNvidia.enable {
    environment.systemPackages = [ pkgs.nvidia-container-toolkit ];

    # Create Docker daemon.json with NVIDIA runtime
    systemd.tmpfiles.rules = [
      "f /etc/docker/daemon.json 0644 root root -"
    ];

    systemd.services.docker.preStart = ''
      mkdir -p /etc/docker
      cat > /etc/docker/daemon.json <<EOF
      {
        "runtimes": {
          "nvidia": {
            "path": "${nvidiaRuntimePath}",
            "runtimeArgs": []
          }
        },
        "default-runtime": "nvidia"
      }
      EOF
    '';
  };
}
