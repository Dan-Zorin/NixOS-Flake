{ config, pkgs, ...}:
 
{
  imports = [
    ./hardware.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  time.timeZone = "America/Panama";

  environment.pathsToLink = [ "/share/xsessions" ];

  # Display + X11 settings
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.displayManager.startx.enable = true;
  services.dbus.enable = true;

  # Enable Mchose Web Hub detect keyboard
  services.udev.extraRules = ''
  SUBSYSTEM=="usb", ATTR{idVendor}=="41e4", ATTR{idProduct}=="2116", MODE="0666", TAG+="uaccess"
  '';
  
  #Polkit session agent
  security.polkit.enable = true;


  #Daemos services
  services.emacs = {
    enable = true;
    package = pkgs.emacs; # replace with emacs-gtk, or a version provided by the community overlay if desired.
  };

  
  #Qtile Service with Extra Package included
  services.xserver.windowManager.qtile = {
  	enable = true;
  	extraPackages = python3Packages: with python3Packages; [
 	qtile-extras
	];
	};




  #Thunar plugins 
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  #Allow Shell To Operate
  programs.fish.enable = true;

  users.users.zorin ={
 	isNormalUser = true;
 	extraGroups = [ "wheel" "video" "input" "tty" ];
 	shell = pkgs.fish;
  };

  fonts.packages = with pkgs; [
	font-awesome

  ];

  environment.sessionVariables = {
  	LIBVA_DRIVER_NAME = "nvidia";
  	VDPAU_DRIVER = "nvidia";
  	__GLX_VENDOR_LIBRARY_NAME = "nvidia";
  	MOZ_ENABLE_WAYLAND = "1";  # if using Firefox/Wayland
  	NVD_BACKEND = "direct";    # For Vulkan
  }; 
  environment.systemPackages = with pkgs;[
	lxsession
	xterm
	dconf
	git 
	vim
	libva
  	libvdpau
	pavucontrol
  	vaapiVdpau
  	vdpauinfo
  	libva-utils
  	vulkan-tools
        xfce.thunar
  	xfce.thunar-volman         # volume management
  	xfce.thunar-archive-plugin # archive support
  	xfce.thunar-media-tags-plugin # media tag editing
 	gvfs                       # auto-mount support
	linuxKernel.packages.linux_libre.cpupower
       
  ];

  system.stateVersion = "25.05";
}
