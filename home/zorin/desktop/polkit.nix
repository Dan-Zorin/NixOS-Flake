{ config, pkgs, ... }:

{
  # Polkit authentication agent

  # lxsession polkit agent
  home.packages = with pkgs; [
    lxsession  # Includes lxpolkit
  ];

}