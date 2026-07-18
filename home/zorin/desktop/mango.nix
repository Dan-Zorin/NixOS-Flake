{ config, pkgs, inputs, ... }:

{

  #Enable Hyprland With UWSM support


  # MangoWC configuration files
  home.file.".config/mango" = {
    source = ../../../dotfiles/mango;
    recursive = true;
  };

  # Optional: MangoWC-specific packages including support for X11
  home.packages = with pkgs; [
    swaybg           # Wallpaper daemon
    wl-clipboard     # Clipboard utilities
    flameshot        # Screenshot tool
    slurp            # Region selector
  ];
}