{ config, pkgs, ... }:

{
  # Enable NVIDIA drivers
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting is required
    modesetting.enable = true;

    # Enable power management (experimental, can cause sleep/suspend issues)
    powerManagement.enable = false;

    # Fine-grained power management (turns off GPU when not in use)
    # Experimental and only works on modern NVIDIA GPUs (Turing+)
    powerManagement.finegrained = false;

    # Use the open source kernel module (for newer cards)
    # Set to false if you have compatibility issues
    open = false;

    # Enable the NVIDIA settings menu
    nvidiaSettings = true;

    # Select the appropriate driver version
    # Options: "stable", "beta", "production", or a specific version
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  # Enable OpenGL with NVIDIA
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Environment variables for NVIDIA on Wayland
  environment.sessionVariables = {
    # Enable NVIDIA on Wayland
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";

    # Fixes for some applications
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  # Kernel parameters for NVIDIA
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"  # Better HDMI detection
    "video=HDMI-A-1:1920x1080@60e"  # Force HDMI to 60Hz (e = enable)
    # Uncomment if you have suspend issues:
     "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ];
}