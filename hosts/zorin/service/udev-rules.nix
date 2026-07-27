{ config, pkgs, ... }:
{
  services.udev.extraRules = ''
    # MCHOSE Ace68-II keyboard - HID access for VIA/webapp configuration
    KERNEL=="hidraw*", ATTRS{idVendor}=="41e4", ATTRS{idProduct}=="2116", MODE="0660", TAG+="uaccess"
  '';
}