{ config, pkgs, unstable, ...}:
 
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
    ./Modules/PlexDocker.nix
    ./hardware.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  boot.kernelModules = [  "nct6775" "coretemp" ];

  networking.hostName = "nixos";
  time.timeZone = "America/Panama";

  environment.pathsToLink = [ "/share/xsessions" ];

  virtualisation.docker.enable = true;
  hardware.nvidia-container-toolkit.enable  = true;

  # Enable Xorg Server and Coolbits for  power  management
  services.xserver = {
  enable = true;
  videoDrivers = [ "nvidia" ];
  deviceSection = ''
    Option "Coolbits" "28" 
  '';
  };

  # Polkit session agent
   security.polkit.enable = true;

  services.openssh = {
  enable = true;
  settings = {
    PermitRootLogin = "no";
    PasswordAuthentication = true;
  };
};

networking.firewall.allowedTCPPorts = [ 22 ];

  #Thunar plugins 
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  #Allow Shell To Operate
  programs.fish.enable = true;

  #Users Zorin
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
	docker
	lxsession
	xterm
	wget
	dconf
	lm_sensors
	clang
	perl
	git	
	bash
	lm_sensors
  	fanctl
	unrar
 	vim
	nvidia-container-toolkit
	libva
  	libvdpau
	plasma5Packages.kdeconnect-kde
	pavucontrol
  	libva-utils
  	vulkan-tools
        xfce.thunar
  	xfce.thunar-volman 
  	xfce.thunar-archive-plugin 
  	xfce.thunar-media-tags-plugin
 	gvfs
  ];

  system.stateVersion = "25.05";
}
