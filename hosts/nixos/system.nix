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

  #Service Management 
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia"];
  #services.xserver.displayManager.startx.enable = true;
  services.xserver.windowManager.qtile.enable = true;

 # Add Home Manager qtile as system-wide session
  environment.etc."xdg/xsessions/qtile-hm.desktop".text = ''
    [Desktop Entry]
    Name=Qtile-HM
    Comment=Qtile from Home Manager
    Exec=/home/zorin/.nix-profile/bin/qtile start
    Type=Application
  '';
  
  #DisplayManager
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.autoLogin.enable = false;
  services.xserver.displayManager.autoLogin.user = "zorin";
  services.xserver.displayManager.sessionCommands = ''
    # This ensures both system and HM qtile are available
  '';

  #Allow Shell To Operate
  programs.fish.enable = true;

  users.users.zorin ={
 	isNormalUser = true;
 	extraGroups = [ "wheel" "video" ];
 	shell = pkgs.fish;
  };
 
  environment.systemPackages = with pkgs; [
	home-manager
	xterm
	git 
 	vim
  ];

  system.stateVersion = "25.05";
}
