{ config, pkgs, ... }:

{
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    steamtinkerlaunch
    steam-run
    gamescope
    lutris
    protonplus
  ];
}
