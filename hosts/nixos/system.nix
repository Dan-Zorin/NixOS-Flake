{ configs, pkgs, ...}:
 
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
  services.xserver.desktopManager.xterm.enable = false];
 

  #Allow Shell To Operate
  programs.fish.enable = true;

  users.users.zorin ={
 	isNormalUser = true;
 	extraGroups = [ "wheel" "video" ];
 	shell = pkgs.fish;
  };
 
  environment.systemPackages = with pkgs;[
	xterm
	git 
 	vim
  ];

  system.stateVersion = "25.05";
}
