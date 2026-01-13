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
    ./Modules/Winapp.nix
    ./Modules/KdeApp.nix
    ./Modules/protonhax.nix
    ./Modules/Hyprland.nix
    ./hardware.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  boot.kernelModules = [ "ntsync" "nct6774" "coretemp" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ ];
  boot.blacklistedKernelModules = [ "nouveau" "nvidiafb" ];


  services.protonhax.enable = true;
  hardware.steam-hardware.enable = true;
  services.udev.packages = [
  pkgs.game-devices-udev-rules
  ];
  

  networking.hostName = "nixos";
  time.timeZone = "America/Panama";

  environment.pathsToLink = [ "/share/xsessions" ];

   programs.coolercontrol.enable = true;

  # Enable Virtual Machine Manager With Support
  winapp.enable = true;

  # Enable Xorg Server and Coolbits for  power  management
  services.xserver = {
  enable = true;
  videoDrivers = [ "nvidia" ];
  deviceSection = ''
    Option "Coolbits" "28"
    Option "ModeDebug" "true"
    Option "UseEdidDpi" "false"
    Option "ModeValidation" "AllowNonEdidModes"
    Option "ExactModeTimingsDVI" "True"

  '';
  };

  # Polkit session agent.
   security.polkit.enable = true;
  

  # Open SSH service.
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
  nerd-fonts.blex-mono
  ];

  systemd.services.librespot = {
  wantedBy = [ "multi-user.target" ];
  description = "Spotify Connect daemon";
  serviceConfig = {
    ExecStart = "${pkgs.librespot}/bin/librespot \
      --name 'Strawberry Connect' \
      --backend alsa \
      --device default \
      --bitrate 320 \
      --enable-volume-normalisation true"; 
    Restart = "always";
  };
};


  environment.systemPackages = with pkgs;[
  jetbrains.idea-community
  jdk17
  linuxKernel.packages.linux_xanmod_latest.cpupower
  gst_all_1.gstreamer
  gst_all_1.gst-plugins-base
  gst_all_1.gst-plugins-good
  gst_all_1.gst-plugins-bad
  gst_all_1.gst-plugins-ugly
  gst_all_1.gst-libav
  rustdesk-flutter
  ibm-plex
  nautilus
  xorg.xkill
  protontricks
  duckstation
  docker
  gamemode
  lxsession
  gst_all_1.gst-plugins-rs
  libxcvt
  xterm
	lact
	wget
	dconf
	waydroid
	lm_sensors
	clang
	perl
	git	
	bash
	librespot
  lm_sensors
  tree
  fanctl
	unrar
	vim
	nvidia-container-toolkit
	libva
	libvdpau
  kdePackages.kdeconnect-kde
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
