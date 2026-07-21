{ config, pkgs, lib, ... }:

{
  # ==========================================
  # Laptop Power Management
  # ==========================================
  # NOTE: option names below should be double-checked with `manix` or a
  # dry build (see AGENTS.md) once you're on the real machine -- this repo
  # was previously desktop-only and these are new to timothy.

  powerManagement.enable = true;

  # Handles CPU governor / power-saving profiles; has a GUI toggle & is
  # what GNOME/KDE-adjacent tools expect. Works fine standalone too.
  services.power-profiles-daemon.enable = true;

  services.upower.enable = true;

  # Suspend on lid close
  services.logind.lidSwitch = "suspend";

  # SSD/NVMe trim on a timer instead of continuous discard
  services.fstrim.enable = true;

  # Thermal management for AMD laptops
  services.thermald.enable = lib.mkDefault false; # thermald is Intel-only; left disabled
}
