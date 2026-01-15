{ config, pkgs, ... }:

{
  # Hyprland configuration files
  home.file.".config/hypr" = {
    source = ../../../dotfiles/hypr;
    recursive = true;
  };

  # Optional: Hyprland-specific packages
  home.packages = with pkgs; [
    hyprpaper        # Wallpaper daemon
    hypridle         # Idle daemon
    hyprlock         # Screen locker
    hyprpicker       # Color picker
    wl-clipboard     # Clipboard utilities
    grim             # Screenshot tool
    slurp            # Region selector
  ];
}