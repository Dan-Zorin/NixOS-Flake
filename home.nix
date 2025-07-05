{ config, pkgs, ... }:

{
 home.username = "zorin";
 home.homeDirectory = "/home/zorin";

 home.file. ".config/picom/picom.conf" ={
	source = ./picom/picom.conf;
 };
 home.file.".config/ghostty/config" = {
   source = ./ghostty/config;
 };
 home.stateVersion = "24.05";
 
 home.file.".config/nvim" = {
  source = fetchGit {
    url = "https://github.com/NvChad/NvChad";
    rev = "main"; # or a specific commit
   };
 };

 home.file.".config/qtile/config.py".source = ./qtile/config.py;
# home.file.".config/qtile/autostart.sh" = {
#	source = ./qtile/autostart.sh; 
#	executable = true;

 #};
 # home.file.".config/qtile/widgets/mywidget.py".source = ./qtile/widgets/mywidget.py;

}
