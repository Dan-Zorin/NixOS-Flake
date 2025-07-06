{ config, pkgs, ... }:

{
  home.username = "zorin";
  home.homeDirectory = "/home/zorin";
  home.stateVersion = "25.05";

  # Enable fish shell
  programs.fish.enable = true;

  # Optional: set default shell
  # You should also set this in configuration.nix under users.users.zorin.shell
  # programs.zsh.enable = true;

  
  #Home user packages 
  home.packages = with pkgs; [
  neovim
  home-manager
  discord
  vim
  curl
  vivaldi
  vivaldi-ffmpeg-codecs
  picom
  ghostty
  gh
  rofi
  xfce.thunar
  feh
  btop
  ];	
 
  # File definitions (relative to flake root)
  home.file.".config/picom/picom.conf" = {
    source = ../../config/picom/picom.conf;
  };

  home.file.".config/ghostty/config" = {
    source = ../../config/ghostty/config;
  };

  home.file.".config/nvim" = {
    source = builtins.fetchGit {
      url = "https://github.com/NvChad/NvChad";
      rev = "a792fd1d96c1511a165b18911164baa28bf1d6f4";  # Pin to a commit for reproducibility
    };
  };

  home.file.".config/qtile/config.py" = {
    source = ../../config/qtile/config.py;
  };

  home.file.".config/qtile/autostart.sh" = {
    source = ../../config/qtile/autostart.sh;
     executable = true;
  };

  # Example: You can add starship or other programs here
  # programs.starship.enable = true;
}
