{ config, pkgs, ... }:

{
  # ==========================================
  # AMD Integrated Graphics
  # ==========================================
  # No proprietary driver needed -- amdgpu (kernel) + Mesa RADV (userspace)
  # handle everything. This replaces zorin's nvidia.nix.

  services.xserver.videoDrivers = [ "amdgpu" ];

  # Load amdgpu early so the boot splash/console use the right driver
  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa
      libva
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      mesa
    ];
  };

  environment.sessionVariables = {
    # VA-API on AMD via Mesa (radeonsi)
    LIBVA_DRIVER_NAME = "radeonsi";
  };
}
