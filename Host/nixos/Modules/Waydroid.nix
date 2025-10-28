{ config, pkgs, lib, ... }:

let
  cfg = config.services.waydroid;
in
{
  options.services.waydroid = {
    enable = lib.mkEnableOption "Waydroid container support";
  };

  config = lib.mkIf cfg.enable {
    # Waydroid core packages
    environment.systemPackages = with pkgs; [
      waydroid
      gamescope
      lxc
      python3
    ];

    # Required kernel modules for Waydroid
    boot.extraModulePackages = with config.boot.kernelPackages; [
      ashmem_linux
      binder_linux
    ];

    boot.kernelModules = [ "binder_linux" "ashmem_linux" ];
    boot.kernelParams = [ "nvidia_drm.modeset=1" ];

    # NVIDIA Wayland / GBM support for Gamescope
    hardware.nvidia = {
      modesetting.enable = true;
      open = false;
      powerManagement.enable = false;
      nvidiaSettings = true;
    };

    environment.variables = {
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      LIBVA_DRIVER_NAME = "nvidia";
    };

    # Optional: systemd service for container management
    systemd.services.waydroid-container = {
      description = "Waydroid container service";
      after = [ "network.target" "local-fs.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.waydroid}/bin/waydroid container start";
        ExecStop = "${pkgs.waydroid}/bin/waydroid container stop";
        Restart = "on-failure";
      };
    };

    # Helpful message on activation
    system.activationScripts.waydroid = ''
      echo "👉 Waydroid module enabled. Run:"
      echo "   sudo waydroid init"
      echo "   gamescope -W 1920 -H 1080 -- waydroid show-full-ui"
    '';
  };
}
