{ config, pkgs, ... }:

{
 services.udev.extraRules = ''
    SUBSYSTEM=="input", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="01a0", MODE="0666"
    
    # MCHOSE Ace68-II keyboard (vendor: 41e4, product: 2116)
    SUBSYSTEM=="usb", ATTRS{idVendor}=="41e4", ATTRS{idProduct}=="2116", MODE="0666", TAG+="uaccess"
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="41e4", ATTRS{idProduct}=="2116", MODE="0666", TAG+="uaccess"
  '';
}
