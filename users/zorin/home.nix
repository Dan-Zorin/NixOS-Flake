{ config, pkgs, ... }:

{
  home.username = "zorin";
  home.homeDirectory = "/home/zorin";
  home.stateVersion = "25.05";
  home.packages = import ./packages.nix { inherit pkgs; };

  # Optional: set default shell
  # You should also set this in configuration.nix under users.users.zorin.shell
   programs.fish.enable = true;

  # Qtile starting by using startx
  home.file.".xinitrc".text = ''
  #!/usr/bin/bash

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
 

  #Kitty Terminal 
  home.file.".config/kitty/kitty.conf".text = ''
    font_family      FiraCode Nerd Font
    bold_font        auto
    italic_font      auto
    bold_italic_font auto
    font_size        11.0

    background_opacity 0.90
    enable_audio_bell no
    confirm_os_window_close 0
    window_padding_width 5

   '';
 
  #Starship terminal assistan
  programs.starship.enable = true;
  
  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
    extraConfig = ''
      (setq standard-indent 2)
    '';
  };

  #DuckStation Emulator
  home.file.".local/bin/duckstation-sync.sh" = {
    text = ''
      #!/usr/bin/env bash

      # Launch DuckStation
      duckstation-qt

      # Sync after quit
       rsync -av --delete \
        ~/Games/DuckStation/memcards/ \
         ~/Dropbox/DuckStation/memcards/
    '';
    executable = true;
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
