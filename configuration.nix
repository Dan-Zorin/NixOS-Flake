{ configs, pkgs, ...}:
   let
  myQtile = pkgs.python3.withPackages (ps: with ps; [
  qtile
  qtile-extras
  ]);
  in
 { 
	imports = [
	./hardware-configuration.nix
	];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  time.timeZone = "America/Panama";

  #Service Management 

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia"];
  services.xserver.displayManager.startx.enable = true;
  services.xserver.windowManager.qtile.enable = true;
  
  #intel Service


  users.users.zorin ={
 	isNormalUser = true;
 	extraGroups = [ "wheel" "video" ];
 	shell = pkgs.bash;
  };
 
  environment.systemPackages = with pkgs; [
	neovim
	discord
	git 
 	vim
 	curl
 	vivaldi 
	vivaldi-ffmpeg-codecs
   	picom
	ghostty 
	gh
   	xterm 
	fish
   	rofi 
	xfce.thunar
	feh
   	myQtile

 ];

  system.stateVersion = "24.05";
}
