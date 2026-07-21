{ config, pkgs, ... }:

{
  # NOTE: set this to hardware.cpu.intel.updateMicrocode if timothy turns
  # out to have an Intel CPU (AMD GPU doesn't imply AMD CPU). Check with
  # `lscpu` on the laptop.
  hardware.cpu.amd.updateMicrocode = true;

  # Bootloader configuration
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    systemd-boot.consoleMode = "max";
    timeout = 10;
  };

  # NOTE: zorin hardcodes a fixed-resolution kernel param
  # ("video=1920x1080@60") for its desktop monitor. Left out here since
  # a laptop panel's native mode should be autodetected; add one back only
  # if you hit boot-console resolution issues.

  boot.plymouth = {
    enable = true;
  };
  boot.consoleLogLevel = 3;
  boot.kernelPackages = pkgs.linuxPackages;

  # Optional: kernel modules
  # boot.kernelModules = [ "kvm-amd" ];
}
