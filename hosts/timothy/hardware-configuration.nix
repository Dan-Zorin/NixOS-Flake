# ==========================================================================
# PLACEHOLDER -- generate this on the actual laptop, do not use as-is
# ==========================================================================
#
# This file is machine-specific (disk UUIDs, partition layout, detected
# kernel modules) and can't be written ahead of time. On the laptop:
#
#   1. Boot the NixOS installer USB.
#   2. Partition/format the disk (or let the graphical installer do it).
#   3. Mount the target filesystem at /mnt.
#   4. Run:  nixos-generate-config --root /mnt
#   5. Copy the resulting /mnt/etc/nixos/hardware-configuration.nix over
#      this file (keep this exact filename/path).
#   6. Then from this flake:
#        sudo nixos-install --flake .#timothy
#
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # Real values will be filled in by nixos-generate-config, e.g.:
  # boot.initrd.availableKernelModules = [ ... ];
  # boot.initrd.kernelModules = [ ... ];
  # boot.kernelModules = [ ... ];
  # boot.extraModulePackages = [ ... ];
  #
  # fileSystems."/" = { device = "/dev/disk/by-uuid/..."; fsType = "..."; };
  # fileSystems."/boot" = { device = "/dev/disk/by-uuid/..."; fsType = "vfat"; };
  #
  # swapDevices = [ ... ];
  # networking.useDHCP = lib.mkDefault true;
  # hardware.cpu.amd.updateMicrocode = lib.mkDefault true; # or intel, per lscpu
}
