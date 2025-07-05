{ configs, pkgs, ...}:

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
  #services.xserver.displayManager.startx.enable = true;
  services.xserver.windowManager.qtile.enable = true;
  
  #DisplayManager
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "zorin";
  
  #Allow Shell To Operate
  programs.fish.enable = true;

  users.users.zorin ={
 	isNormalUser = true;
 	extraGroups = [ "wheel" "video" ];
 	shell = pkgs.fish;
  };
 
  environment.systemPackages = with pkgs; [
	xterm
	git 
 	vim
  ];

  system.stateVersion = "25.05";
}
