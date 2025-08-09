{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
    windowManager.qtile.enable = true;
  };

  environment.systemPackages = with pkgs; [
    qtile-extras
  ];
}

