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
  home.file.".config/ghostty/config" = {
    source = ../../config/ghostty/config;
  };

  # Example: You can add starship or other programs here
  # programs.starship.enable = true;
}
