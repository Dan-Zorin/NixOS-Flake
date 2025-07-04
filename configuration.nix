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
  services.xserver.displayManager.startx.enable = true;
  services.xserver.windowManager.qtile.enable = true;

  users.users.zorin ={
 	isNormalUser = true;
 	extraGroups = [ "wheel" "video" ];
 	shell = pkgs.bash;
  };

  environment.systemPackages = with pkgs; [
   git vim curl vivaldi vivaldi-ffmpeg-codecs
   picom ghostty
   xterm
   rofi feh
  ];

  system.stateVersion = "24.05";
}
