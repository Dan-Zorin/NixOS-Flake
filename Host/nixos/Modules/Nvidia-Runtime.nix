# modules/docker-nvidia.nix
{ config, pkgs, lib, ... }:

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

    # Ensure daemon.json exists before Docker starts
    environment.etc."docker/daemon.json".text = ''
      {
        "runtimes": {
          "nvidia": {
            "path": "${nvidiaRuntimePath}",
            "runtimeArgs": []
          }
        },
        "default-runtime": "nvidia"
      }
    '';
  };
}

