{ config, pkgs, unstable, ... }:

{
  #Nvidia hardware manageger 
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;	 
    package = unstable.linuxPackages.nvidiaPackages.latest;
    # package = config.boot.kernelPackages.nvidiaPackages.latest;   
  };

  hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
     ];
   };

  # Enable the NVIDIA Container Toolkit for CDI support
  hardware.nvidia-container-toolkit.enable = true;
  
  virtualisation.docker.extraOptions = ''
  --add-runtime=nvidia=/run/current-system/sw/bin/nvidia-container-runtime
  --default-runtime=nvidia
  '';

  #Nvidia Hardware environment variables
  environment.sessionVariables = {
        LIBVA_DRIVER_NAME = "nvidia";
        VDPAU_DRIVER = "nvidia";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        MOZ_ENABLE_WAYLAND = "1";
        NVD_BACKEND = "direct";    # For Vulkan

    };

  boot.kernelParams = [ "nvidia-drm.modeset=1" ];

}
