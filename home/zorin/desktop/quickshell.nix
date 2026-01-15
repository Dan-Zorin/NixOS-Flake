{ config, pkgs, ... }:

{
  # Quickshell configuration files
  home.file.".config/quickshell" = {
    source = ../../../dotfiles/quickshell;
    recursive = true;
  };

  # Quickshell package
  home.packages = with pkgs; [
    quickshell
  ];
}