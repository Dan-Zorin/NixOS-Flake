{ config, pkgs, ...}:
 
{
  imports = [
    ./hardware.nix 
    ./docker.nix  

  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest; 
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];
  boot.kernelModules = [ "cpufreq_ondemand" "cpufreq_conservative" "cpufreq_userspace" ];

  networking.hostName = "nixos";
  time.timeZone = "America/Panama";

  environment.pathsToLink = [ "/share/xsessions" ];

  # Display + X11 settings
  services.xserver = {
  enable = true;
  videoDrivers = [ "nvidia" ];

  # Inject custom options into the X11 Device section
  deviceSection = ''
    Option "Coolbits" "28"
  '';

  };

  services.xserver.displayManager.startx.enable = true;
  services.dbus.enable = true;

  # Enable Mchose Web Hub detect keyboard
  services.udev.extraRules = ''
  KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="41e4", ATTRS{idProduct}=="2116", MODE="0660", GROUP="input", TAG+="uaccess"
  '';

  #Polkit session agent
   security.polkit.enable = true;

  
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
 	extraGroups = [ "wheel" "video" "input" "tty" "plugdev" "dropbox"];
 	shell = pkgs.fish;
  };
  users.groups.plugdev = { };
  
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
	lm_sensors
 	git 
	unrar
 	vim
	libva
  	libvdpau
	plasma5Packages.kdeconnect-kde
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
