{ config, pkgs, ... }:

{

  #Enable Hyprland With UWSM support


  # Hyprland configuration files
  home.file.".config/hypr" = {
    source = ../../../dotfiles/hypr;
    recursive = true;
  };

  # Optional: Hyprland-specific packages including support for X11
  home.packages = with pkgs; [
    swaybg           # Wallpaper daemon
    hypridle         # Idle daemon
    hyprlock         # Screen locker
    hyprpicker       # Color picker
    wl-clipboard     # Clipboard utilities
    flameshot        # Screenshot tool
    slurp            # Region selector
  ];
}