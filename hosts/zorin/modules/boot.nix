{ config, pkgs, ... }:

{
    hardware.cpu.intel.updateMicrocode = true;

  # Bootloader configuration
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    boot.loader.systemd-boot.consoleMode = "max";
    # Optional: timeout before auto-boot
    timeout = 10;
  };



  boot.kernelParams = [
    "video=1920x1080@60"   # match your actual monitor's native resolution
  ];

  boot.plymouth = {
    enable = true;
    # theme = "...";
  };
  boot.consoleLogLevel = 3;
  boot.kernelPackages = pkgs.linuxPackages;

  # Optional: kernel modules
  # boot.kernelModules = [ "kvm-intel" "kvm-amd" ];

  # Optional: disable specific modules
  boot.blacklistedKernelModules = [ "nouveau" ];

}