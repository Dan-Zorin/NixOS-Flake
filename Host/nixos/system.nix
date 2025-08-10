{ config, pkgs, ...}:
 
{
  imports = [
    ./Modules/Audio.nix
    ./Modules/Gaming.nix
    ./Modules/Nvidia.nix
    ./Modules/Qtile.nix
    ./Modules/Docker.nix
    ./Modules/Keyboard.nix
    ./Modules/Network.nix
    ./Modules/Virtualization.nix  
    ./hardware.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "cpufreq_ondemand" "cpufreq_conservative" "cpufreq_userspace" ];

  networking.hostName = "nixos";
  time.timeZone = "America/Panama";

  environment.pathsToLink = [ "/share/xsessions" ];

  # Enable Xorg Server and Coolbits for  power  management
  services.xserver = {
  enable = true;
  videoDrivers = [ "nvidia" ];
  deviceSection = ''
    Option "Coolbits" "28"
  '';
  };

  # Enable Mchose Web Hub detect keyboard
  services.udev.extraRules = ''
  KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="41e4", ATTRS{idProduct}=="2116", MODE="0660", GROUP="input", TAG+="uaccess"
  '';

  # Polkit session agent
   security.polkit.enable = true;


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
  	xfce.thunar-volman 
  	xfce.thunar-archive-plugin 
  	xfce.thunar-media-tags-plugin
 	gvfs                       
	linuxKernel.packages.linux_libre.cpupower
  ];

  system.stateVersion = "25.05";
}
