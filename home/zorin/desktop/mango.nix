{ config, pkgs, inputs, ... }:

{

  #Enable Hyprland With UWSM support


  # Hyprland configuration files
  home.file.".config/mango" = {
    source = ../../../dotfiles/mango;
    recursive = true;
  };

  # Optional: Hyprland-specific packages including support for X11
  home.packages = with pkgs; [
    swaybg           # Wallpaper daemon
    wl-clipboard     # Clipboard utilities
    flameshot        # Screenshot tool
    slurp            # Region selector
  ];
}