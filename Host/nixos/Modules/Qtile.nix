{ config, pkgs, ...}:
 
{

#Qtile Service with Extra Package included
  services.xserver.windowManager.qtile = {
  	enable = true;
  	extraPackages = python3Packages: with python3Packages; [
 	qtile-extras
	];
	};

#etartx Service Fallback
services.xserver.displayManager.startx.enable = true;
services.dbus.enable = true;
services.xserver.displayManager.sddm = {
  enable = true;
#  autoLogin.enable = true;
#  autoLogin.enable = "zorin";
};
}
