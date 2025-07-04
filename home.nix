{ config, pkgs, ... }:

{
 home.username = "zorin";
 home.homeDirectory = "/home/zorin";

 home.file. ".config/picom.conf".text = ''
	backend = "glx";
	vsync = true;
	opacity-rule = ["90:class_g = 'Ghostty'"];
 '';
 home.file.".config/ghostty/config.toml".text = ''
	[terminal]
	opacity = 0.9
     '';
  home.stateVersion = "24.05";
}
