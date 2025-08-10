{ config, pkgs, ...}:
 
{

#Qtile Service with Extra Package included
  services.xserver.windowManager.qtile = {
  	enable = true;
  	extraPackages = python3Packages: with python3Packages; [
 	qtile-extras
	];
	};

#Startx Service Fallback
services.xserver.displayManager.startx.enable = true;
services.dbus.enable = true;

}