{ config, pkgs, ... }:

{
    hardware.cpu.intel.updateMicrocode = false;

  # Bootloader configuration
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;

    # Optional: timeout before auto-boot
    timeout = 5;
  };

  # Or if you use GRUB instead:
  # boot.loader.grub = {
  #   enable = true;
  #   device = "nodev";
  #   efiSupport = true;
  #   useOSProber = true;  # Detect other OS
  # };

  # Kernel parameters
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  # Optional: kernel modules
  # boot.kernelModules = [ "kvm-intel" "kvm-amd" ];

  # Optional: disable specific modules
  boot.blacklistedKernelModules = [ "nouveau" ];

  # Plymouth boot splash (optional)
  boot.plymouth.enable = true;
}