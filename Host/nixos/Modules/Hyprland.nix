{ config, pkgs, ... }:

{
environment.systemPackages = with pkgs; [
  hyperland
  waybar
  wlroots
  mako   # notification daemon
  wofi   # launcher
];

}
