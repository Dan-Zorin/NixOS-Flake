{ config, pkgs, ... }:

{
  home.username = "zorin";
  home.homeDirectory = "/home/zorin";
  home.stateVersion = "25.05";


  # Optional: set default shell
  # You should also set this in configuration.nix under users.users.zorin.shell
   programs.fish.enable = true;

  
  #Home user packages 
  home.packages = with pkgs; [
  home-manager
  gnome-disk-utility
  vesktop
  mpv
  noto-fonts-color-emoji
  easyeffects
  curl
  dunst
  vivaldi
  vivaldi-ffmpeg-codecs
  picom
  ghostty
  gh
  rofi
  xfce.thunar
  feh
  btop
  steam
  bottles
  blender
  
  ];


  # Qtile starting by using startx
  home.file.".xinitrc".text = ''
  #!/usr/bin/bash

   # Set up XDG paths
  #export XDG_DATA_DIRS="/run/current-system/sw/share:$${XDG_DATA_DIRS:-/usr/share}"
  #export XDG_CONFIG_DIRS="/etc/xdg"

  # Start Qtile 
  exec qtile start 
  '';

  # Import entire qtile config folder
  home.file.".config/qtile" = {
    source = ../../config/qtile;
    recursive = true;
  };

  # Override just autostart.sh to ensure it is executable
  home.file.".config/qtile/autostart.sh" = {
    source = ../../config/qtile/autostart.sh;
    executable = true;
  };
  
  #Picom Window compositor
  home.file.".config/picom/picom.conf" = { 
    source = ../../config/picom/picom.conf;
  };
  
  # File definitions (relative to flake root)
  home.file.".config/ghostty/config" = {
    source = ../../config/ghostty/config;
  };
 
  #Starship terminal assistan
  programs.starship.enable = true;
  
  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
    extraConfig = ''
      (setq standard-indent 2)
    '';
  };


  #GTK system theme
  dconf.enable = true;
    gtk = {
    enable = true;

  theme = {
    name = "Nordic";
    package = pkgs.nordic;
  };

  iconTheme = {
    name = "Papirus";
    package = pkgs.papirus-icon-theme;
  };

  cursorTheme = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    };
  };
}
