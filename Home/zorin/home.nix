{ config, pkgs, ... }:

{
  home.username = "zorin";
  home.homeDirectory = "/home/zorin";
  home.stateVersion = "25.11";
  home.packages = import ./packages.nix { inherit pkgs; };

  imports = [
    ./Modules/Tmux.nix 
  ];

  # Optional: set default shell
  # You should also set this in configuration.nix under users.users.zorin.shell
   programs.fish = {
  enable = true;
  interactiveShellInit = ''
    if status is-interactive
        if not set -q TMUX
            tmux attach -t main || tmux new -s main
        end
    end

    set -x GLFW_PLATFORM x11

  '';
   };
  
  # Import entire qtile config folder
  home.file.".config/hypr" = {
    source = ../../Home/Dotfile/hypr;
    recursive = true;
  };

  #Picom Window compositor
  home.file.".config/picom/picom.conf" = { 
    source = ../../config/picom/picom.conf;
  };
 

  #Kitty Terminal 
  home.file.".config/kitty/kitty.conf".text = ''
   # BEGIN_KITTY_THEME
   # Solarized Osaka
   include current-theme.conf
   # END_KITTY_THEME

   font_family  BlexMono Nerd Font
   font_size 8
   bold_font        auto
   italic_font      auto
   bold_italic_font auto


   background_opacity 0.10
   background_blur 30


   macos_show_window_title_in none
   macos_titlebar_color #1a1b26
   macos_menubar_title_max_length 0
   hide_window_decorations titlebar-only
   '';
 
  #Starship terminal assistan
  programs.starship.enable = true; 
  
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
