{ config, pkgs, ... }:

{
  services.udev.extraRules = ''
    SUBSYSTEM=="input", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="01a0", MODE="0666"
  '';
}
